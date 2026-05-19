{ pkgs, ... }:

let
  # ─────────────────────────────────────────────────────────────────────────
  # WallSelect – Lua port dari bash wallpaper selector
  #
  # Strategi wrapping:
  #   • pkgs.writeScriptBin  → buat script dengan shebang Lua dari Nix store
  #   • ${pkgs.xxx}          → Nix interpolasi path tool langsung ke source Lua
  #   • $VAR (tanpa kurung)  → shell syntax yang AMAN dari Nix interpolasi
  #   • ${...} shell syntax  → DIHINDARI; logika seperti ${A%.*} dipindah ke Lua
  # ─────────────────────────────────────────────────────────────────────────

  loaders = pkgs.buildEnv {
    name = "gdk-pixbuf-loaders";
    paths = with pkgs; [
      librsvg
      gdk-pixbuf
      webp-pixbuf-loader
    ];
  };

  cache =
    pkgs.runCommand "gdk-pixbuf-cache"
      {
        nativeBuildInputs = [ pkgs.gdk-pixbuf.dev ];
      }
      ''
        mkdir -p $out/lib/gdk-pixbuf-2.0/2.10.0

        GDK_PIXBUF_MODULEDIR="${loaders}/lib/gdk-pixbuf-2.0/2.10.0/loaders" \
          ${pkgs.gdk-pixbuf.dev}/bin/gdk-pixbuf-query-loaders \
          > $out/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
      '';

  rofiWithWebp = pkgs.symlinkJoin {
    name = "rofi";
    paths = [ pkgs.rofi ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      # Hapus symlink ke C wrapper yang hardcode GDK_PIXBUF_MODULE_FILE
      rm $out/bin/rofi

      # Buat shell wrapper langsung ke rofi-unwrapped dengan env var kita
      makeWrapper ${pkgs.rofi-unwrapped}/bin/rofi $out/bin/rofi \
        --prefix GIO_EXTRA_MODULES : ${pkgs.dconf.lib}/lib/gio/modules \
        --set GDK_PIXBUF_MODULE_FILE "${cache}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
        --set GDK_PIXBUF_MODULEDIR "${loaders}/lib/gdk-pixbuf-2.0/2.10.0/loaders" \
        --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" \
        --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}" \
        --prefix XDG_DATA_DIRS : "${pkgs.rofi-unwrapped}/share" \
        --prefix XDG_DATA_DIRS : "${pkgs.hicolor-icon-theme}/share"
    '';
  };

  wallSelect = pkgs.writeScriptBin "WallSelect" ''
    #!${pkgs.lua5_4}/bin/lua

    -- ── Tool paths (di-inject Nix saat build, bukan runtime) ─────────────
    local FIND   = "${pkgs.findutils}/bin/find"
    local XARGS  = "${pkgs.findutils}/bin/xargs"
    local MAGICK = "${pkgs.imagemagick}/bin/magick"
    local XXHSUM = "${pkgs.xxHash}/bin/xxhsum"
    local FLOCK  = "${pkgs.util-linux}/bin/flock"
    local ROFI   = "${rofiWithWebp}/bin/rofi"
    local NPROC  = "${pkgs.coreutils}/bin/nproc"

    -- ── Utilities ─────────────────────────────────────────────────────────

    local function trim(s)
      return (s:gsub("^%s+", ""):gsub("%s+$", ""))
    end

    -- Jalankan perintah shell, kembalikan stdout sebagai string
    local function run(cmd)
      local h = io.popen(cmd)
      if not h then return "" end
      local out = h:read("*a"); h:close()
      return trim(out)
    end

    local function read_file(path)
      local f = io.open(path, "r")
      if not f then return nil end
      local line = f:read("*l"); f:close()
      return line
    end

    local function file_exists(path)
      local f = io.open(path, "r")
      if f then f:close(); return true end
      return false
    end

    -- ── Config ────────────────────────────────────────────────────────────

    local home         = os.getenv("HOME")
    local de           = os.getenv("XDG_CURRENT_DESKTOP")
    local username     = os.getenv("USER")
    local current_rice = trim(read_file(home .. "/.config/bspwm/.rice") or "")

    if current_rice == "" then
      io.stderr:write("Error: tidak bisa membaca .rice\n")
      os.exit(1)
    end

    local wall_dir   = home .. "/.config/" .. de .. "/rices/" .. current_rice .. "/wallpapers"
    local cache_dir  = home .. "/.cache/"  .. username .. "/" .. current_rice
    local rofi_theme = home .. "/.config/rofi/themes/WallSelect.rasi"

    os.execute("mkdir -p '" .. cache_dir .. "'")

    -- ── Optimal parallel jobs ─────────────────────────────────────────────

    local function get_optimal_jobs()
      local cores = tonumber(run(NPROC)) or 2
      if     cores <= 2 then return 2
      elseif cores >  4 then return 4
      else                   return cores - 1
      end
    end

    -- ── Generate thumbnails ───────────────────────────────────────────────
    --
    -- Menulis temporary helper script lalu memanggil xargs -P untuk
    -- paralelisme. Helper menerima path gambar sebagai $1.
    --
    -- CATATAN: kita pakai $VAR (tanpa kurung kurawal) di sini agar Nix
    -- tidak mencoba menginterpolasi string shell di dalam source Lua.
    -- Shell tetap mengekspansi $VAR dengan benar.

    local function generate_thumbnails()
      os.execute("rm -f '" .. cache_dir .. "'/.lock_* 2>/dev/null")
      local jobs = get_optimal_jobs()

      local helper = os.tmpname()
      local hf     = assert(io.open(helper, "w"))

      -- Tulis helper script (satu gambar per invokasi)
      hf:write(
        "#!/bin/sh\n"                                                                ..
        "CACHE_DIR='"   .. cache_dir .. "'\n"                                        ..
        "BIN_XXHSUM='"  .. XXHSUM   .. "'\n"                                        ..
        "BIN_MAGICK='"  .. MAGICK   .. "'\n"                                        ..
        "BIN_FLOCK='"   .. FLOCK    .. "'\n"                                        ..
        "\n"                                                                         ..
        "imagen=$1\n"                                                                ..
        "nombre=$(basename \"$imagen\")\n"                                           ..
        "nombre_stem=$(echo \"$nombre\" | sed 's/\\.[^.]*$//')\n"                    ..
        "cache_file=$CACHE_DIR/$nombre_stem.webp\n"                                   ..
        "md5_file=$CACHE_DIR/.$nombre.md5\n"                                         ..
        "lock_file=$CACHE_DIR/.lock_$nombre\n"                                       ..
        "current_md5=$($BIN_XXHSUM \"$imagen\" | cut -d ' ' -f1)\n"                 ..
        "(\n"                                                                        ..
        "  $BIN_FLOCK -x 9\n"                                                       ..
        "  if [ ! -f \"$cache_file\" ] || [ ! -f \"$md5_file\" ] ||\\\n"            ..
        "     [ \"$current_md5\" != \"$(cat \"$md5_file\" 2>/dev/null)\" ]; then\n" ..
        "    $BIN_MAGICK \"$imagen\" -resize 500x500^ -gravity center \\\n"          ..
        "                -extent 500x500 \"$cache_file\"\n"                          ..
        "    echo \"$current_md5\" > \"$md5_file\"\n"                               ..
        "  fi\n"                                                                     ..
        "  rm -f \"$lock_file\"\n"                                                   ..
        ") 9>\"$lock_file\"\n"
      )
      hf:close()

      local find_cmd = string.format(
        "%s '%s' -type f \\("                                               ..
        " -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp'"             ..
        " -o -iname '*.webp' -o -iname '*.avif' \\) -print0",
        FIND, wall_dir
      )
      os.execute(string.format(
        "%s | %s -0 -n 1 -P %d sh '%s'",
        find_cmd, XARGS, jobs, helper
      ))

      os.remove(helper)
      os.execute("rm -f '" .. cache_dir .. "'/.lock_* 2>/dev/null")
    end

    -- ── Bersihkan cache yang tidak punya wallpaper asli ───────────────────

    local function clean_orphan_cache()
      local h = io.popen(
        FIND .. " '" .. cache_dir .. "' -maxdepth 1 -type f -name '*.webp'"
      )
      if not h then return end
      for fpath in h:lines() do
        local stem = fpath:match("([^/]+)%.webp$")
        if stem then
          -- cek apakah ada file asli dengan stem ini (ekstensi apapun)
          local found = run(string.format(
            "%s '%s' -maxdepth 1 -type f -name '%s.*' | head -n 1",
            FIND, wall_dir, stem
          ))
          if found == "" then
            os.remove(fpath)
            os.remove(cache_dir .. "/." .. stem .. ".*")
          end
        end
      end
      h:close()
    end

    -- ── Kumpulkan daftar wallpaper (sorted) ───────────────────────────────

    local function collect_wallpapers()
      local list = {}
      local cmd  = string.format(
        -- %%f → %f setelah string.format (find printf: hanya nama file)
        "%s '%s' -type f \\("                                                ..
        " -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png'"              ..
        " -o -iname '*.webp' -o -iname '*.avif' \\) -printf '%%f\\n'"       ..
        " | LC_ALL=C sort",
        FIND, wall_dir
      )
      local h = io.popen(cmd)
      if not h then return list end
      for fname in h:lines() do table.insert(list, fname) end
      h:close()
      return list
    end

    -- ── Tampilkan rofi picker ─────────────────────────────────────────────

    local function launch_rofi(wallpapers)
      local tmp = os.tmpname()
      local tf  = assert(io.open(tmp, "w"))

      for _, fname in ipairs(wallpapers) do
        -- Strip ekstensi di Lua (pengganti ''${A%.*} dari shell)
        local stem = fname:match("^(.+)%.[^.]+$") or fname

        -- Format rofi: "stem NUL icon US /path/cache/fname LF"
        -- \0  = NUL  (0x00) – pemisah field rofi
        -- \31 = US   (0x1F) – unit separator, sama dengan \037 di shell
        tf:write(stem .. "\0icon\31" .. cache_dir .. "/" .. stem .. ".webp\n")
      end
      tf:close()

      local sel = run(string.format(
        "cat '%s' | %s -dmenu -p WallSelect -theme '%s'",
        tmp, ROFI, rofi_theme
      ))
      os.remove(tmp)
      return sel ~= "" and sel or nil
    end

    -- ── Terapkan wallpaper ────────────────────────────────────────────────

    local function set_wallpaper(selection)
      -- Cari file asli berdasarkan stem (tanpa peduli ekstensi)
      local actual = run(string.format(
        "%s '%s' -maxdepth 1 -type f -name '%s.*' | head -n 1",
        FIND, wall_dir, selection
      ))
      if actual ~= "" then
        os.execute("wall '" .. actual .. "'")
        os.execute("WallSync &")
      end
    end

    -- ── Entry point ───────────────────────────────────────────────────────

    generate_thumbnails()
    clean_orphan_cache()

    local walls = collect_wallpapers()
    local sel   = launch_rofi(walls)
    if sel then set_wallpaper(sel) end
  '';

in
{
  environment.systemPackages = with pkgs; [
    wallSelect
    rofiWithWebp

    gdk-pixbuf.dev
    libavif
    libheif.out
    libheif.bin
  ];

  environment.sessionVariables = {
    GDK_PIXBUF_MODULE_FILE = "${cache}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
  };
}
