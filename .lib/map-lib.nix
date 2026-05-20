# map-lib.nix
# Library untuk auto-mapping file .nix dalam sebuah folder
#
# ┌─────────────────────────────────────────────────────────────────┐
# │  SIGNATURE (3 argumen, extraArgs wajib — pakai {} jika kosong)  │
# ├─────────────────────────────────────────────────────────────────┤
# │  mapFile dir exclude extraArgs                                   │
# │  mapDir  dir exclude extraArgs                                   │
# │  mapAll  dir exclude extraArgs                                   │
# └─────────────────────────────────────────────────────────────────┘
#
# CONTOH PEMAKAIAN:
#
#   let mapLib = import ./lib/map-lib.nix;
#       inherit (mapLib) mapFile mapDir mapAll;
#   in {
#     # tanpa extra args
#     imports = mapFile ./cli [] {};
#     imports = mapDir  ./cli [] {};
#     imports = mapAll  ./cli [] {};
#
#     # dengan extra args → diteruskan ke tiap modul yang di-import
#     imports = mapFile ./cli [] { inherit myLibs; };
#     imports = mapDir  ./cli [] { inherit myLibs inputs; };
#
#     # dengan pengecualian + extra args
#     imports = mapAll  ./cli [ "home.nix" "work" ] { inherit myLibs; };
#   }
#
# SYARAT MODULE YANG MENERIMA extraArgs:
#   Setiap file .nix HARUS berupa FUNGSI, bukan plain attrset.
#
#   ✅ Benar:
#     { myLibs, config, pkgs, lib, ... }:
#     { environment.systemPackages = ...; }
#
#   ❌ Salah (plain attrset tidak bisa menerima args):
#     { environment.systemPackages = ...; }
#
# ⚠  KENDALA (baca bagian bawah file ini)

let
  # ---------------------------------------------------------------------------
  # Internal helpers
  # ---------------------------------------------------------------------------

  readDir = path: builtins.readDir path;

  isNixFile = name: builtins.match ".*\\.nix" name != null;

  normalizeExclude = exclude:
    if builtins.isList exclude then exclude else [ exclude ];

  isExcluded = name: excludeList:
    builtins.elem name (normalizeExclude excludeList);

  # ---------------------------------------------------------------------------
  # wrapModule — inti dari dukungan extraArgs
  #
  # Jika extraArgs kosong ({})  → kembalikan path biasa (perilaku lama)
  # Jika extraArgs berisi data  → kembalikan MODULE FUNCTION yang:
  #   1. Dipanggil oleh module system Nix dengan args standarnya
  #      (config, pkgs, lib, options, ...)
  #   2. Menggabungkan extraArgs ke dalam args tersebut
  #   3. Memanggil `import path` dengan hasil gabungan
  #
  # Urutan merge: extraArgs // moduleSystemArgs
  #   → moduleSystemArgs (config, pkgs, dll) SELALU menang jika ada konflik
  #   → ini mencegah extraArgs menimpa args bawaan module system
  # ---------------------------------------------------------------------------
  wrapModule = path: extraArgs:
    if extraArgs == {}
    then path
    else
      moduleSystemArgs:
        (import path) (extraArgs // moduleSystemArgs);

  # ---------------------------------------------------------------------------
  # mapFile — semua .nix langsung di dalam `dir`
  # ---------------------------------------------------------------------------
  mapFile = dir: exclude: extraArgs:
    let
      entries = readDir dir;
      excList = normalizeExclude exclude;

      nixFiles = builtins.filter
        (name:
          entries.${name} == "regular"
          && isNixFile name
          && !isExcluded name excList
        )
        (builtins.attrNames entries);
    in
      map (name: wrapModule (dir + "/${name}") extraArgs) nixFiles;

  # ---------------------------------------------------------------------------
  # mapDir — semua sub-folder di dalam `dir`
  #   • Ada default.nix → tunjuk ke folder (Nix auto-resolve default.nix)
  #   • Tidak ada       → ambil semua .nix di sub-folder itu
  # ---------------------------------------------------------------------------
  mapDir = dir: exclude: extraArgs:
    let
      entries = readDir dir;
      excList = normalizeExclude exclude;

      subDirs = builtins.filter
        (name:
          entries.${name} == "directory"
          && !isExcluded name excList
        )
        (builtins.attrNames entries);

      importPathsFor = name:
        let
          subPath    = dir + "/${name}";
          subEntries = readDir subPath;
          hasDefault = builtins.hasAttr "default.nix" subEntries
                       && subEntries."default.nix" == "regular";
        in
          if hasDefault
          then [ (wrapModule subPath extraArgs) ]  # berhenti di sini, default.nix pegang kendali
          else mapAll subPath [] extraArgs;         # ← rekursif: turun ke sub-sub-folder
    in
      builtins.concatMap importPathsFor subDirs;

  # ---------------------------------------------------------------------------
  # mapAll — gabungan mapFile + mapDir
  # ---------------------------------------------------------------------------
  mapAll = dir: exclude: extraArgs:
    (mapFile dir exclude extraArgs) ++ (mapDir dir exclude extraArgs);

in
{
  inherit mapFile mapDir mapAll;
}

# =============================================================================
# ⚠  KENDALA DAN BATASAN PENDEKATAN extraArgs
# =============================================================================
#
# [1] SETIAP MODULE HARUS FUNGSI
#     File yang di-import WAJIB berupa fungsi, bukan plain attrset.
#     Plain attrset tidak bisa dipanggil → error "is not a function".
#     Jika kamu punya campuran (sebagian fungsi, sebagian attrset),
#     kamu tidak bisa pakai extraArgs untuk folder itu. Gunakan {} sebagai
#     gantinya dan andalkan _module.args.
#
# [2] extraArgs TIDAK BISA DINAMIS (bergantung pada config/pkgs)
#     extraArgs dievaluasi saat mapFile/mapDir dipanggil, yaitu di tahap
#     let-binding pada flake.nix — SEBELUM module system berjalan.
#     Artinya: extraArgs TIDAK BOLEH berisi config, options, atau apapun
#     yang baru tersedia setelah module system dievaluasi.
#
#     ❌ SALAH:
#       mapFile ./cli [] { inherit myLibs config; }   # config belum ada
#
#     ✅ BENAR:
#       mapFile ./cli [] { inherit myLibs inputs; }   # static values
#
# [3] KONFLIK KEY DENGAN MODULE SYSTEM
#     Jangan gunakan nama key yang sama dengan args bawaan module system:
#     config, pkgs, lib, options, modulesPath, specialArgs.
#     Jika konflik terjadi, moduleSystemArgs MENANG (ini disengaja),
#     tapi tetap membingungkan. Gunakan nama unik: myLibs, myPkgs, dll.
#
# [4] TIDAK ADA ERROR JIKA KEY TIDAK DIPAKAI
#     Jika kamu passing { inherit myLibs; } tapi sebuah module tidak
#     mendeklrasikan myLibs di signature-nya, Nix TIDAK akan error
#     (karena `...` menelan arg tak dikenal). Ini bisa menyembunyikan
#     typo — pastikan setiap modul yang butuh myLibs benar-benar
#     mendeklarasikannya.
#
# [5] REKOMENDASI: TETAP PAKAI _module.args UNTUK KASUS UMUM
#     Untuk meneruskan nilai ke SEMUA module sekaligus tanpa repot,
#     cara paling idiomatik di Nix adalah:
#
#       { _module.args = { inherit myLibs; }; imports = mapAll ./cli [] {}; }
#
#     atau di nixosSystem / homeManagerConfiguration:
#
#       specialArgs = { inherit myLibs; };
#
#     Gunakan extraArgs di map-lib ini hanya jika kamu butuh kontrol
#     per-folder (folder A dapat args X, folder B dapat args Y).
# =============================================================================
