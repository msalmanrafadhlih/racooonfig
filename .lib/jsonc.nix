{ lib, ... }:
# Baca JSON berkomentar (JSONC) — format yang sama dengan settings.json VSCode.
#
# builtins.fromJSON menolak `// ...`, `/* ... */`, dan trailing comma, jadi file
# JSONC yang langsung dibaca akan error "parse error at line N". Fungsi ini
# membuang ketiganya lebih dulu. String yang berisi "//" atau "," tidak disentuh.
# Jumlah baris dipertahankan, jadi nomor baris di pesan error tetap cocok
# dengan file aslinya.
#
#   jsonc = import ./jsonc.nix { inherit lib; };
#   jsonc.readFile ./preferences/appearance.json
let
  isSpace = c: c == " " || c == "\t" || c == "\n" || c == "\r";

  # Mesin state per karakter. mode:
  #   n = normal       s = di dalam string     e = karakter setelah "\" di string
  #   / = baru lihat "/" di luar string
  #   l = komentar baris    b = komentar blok    * = lihat "*" di komentar blok
  # comma/ws = koma yang ditahan (plus spasi setelahnya) sampai karakter
  # berikutnya kelihatan; kalau berikutnya } atau ], koma itu dibuang.
  init = {
    mode = "n";
    out = "";
    comma = false;
    ws = "";
  };

  # Spasi/newline: ikut ditahan kalau ada koma tertunda, supaya urutannya benar.
  space = st: c: if st.comma then st // { ws = st.ws + c; } else st // { out = st.out + c; };

  # Tulis satu karakter ke output. Koma tertunda dikeluarkan dulu,
  # kecuali karakter ini penutup } atau ] (itulah trailing comma).
  emit =
    st: c:
    st
    // {
      out = st.out + (if st.comma then (if c == "}" || c == "]" then st.ws else "," + st.ws) else "") + c;
      comma = false;
      ws = "";
    };

  normal =
    st: c:
    if isSpace c then
      space st c
    else if c == "," then
      # koma baru; koma tertunda sebelumnya (",,") dikeluarkan apa adanya
      (emit st "")
      // {
        comma = true;
      }
    else if c == "/" then
      st // { mode = "/"; }
    else
      emit st c // { mode = if c == "\"" then "s" else "n"; };

  step =
    st: c:
    if st.mode == "s" then
      st
      // {
        out = st.out + c;
        mode =
          if c == "\\" then
            "e"
          else if c == "\"" then
            "n"
          else
            "s";
      }
    else if st.mode == "e" then
      st
      // {
        out = st.out + c;
        mode = "s";
      }
    else if st.mode == "l" then
      if c == "\n" then (space st c) // { mode = "n"; } else st
    else if st.mode == "b" then
      (if c == "\n" then space st c else st) // { mode = if c == "*" then "*" else "b"; }
    else if st.mode == "*" then
      st
      // {
        mode =
          if c == "/" then
            "n"
          else if c == "*" then
            "*"
          else
            "b";
      }
    else if st.mode == "/" then
      if c == "/" then
        st // { mode = "l"; }
      else if c == "*" then
        st // { mode = "b"; }
      else
        # "/" tunggal bukan JSON valid; teruskan saja, biar fromJSON yang menolak
        step (emit st "/" // { mode = "n"; }) c
    else
      normal st c;

  # Teks JSONC → teks JSON murni.
  strip =
    text:
    let
      final = builtins.foldl' step init (lib.stringToCharacters text);
    in
    final.out + (if final.comma then "," + final.ws else "");
in
{
  inherit strip;
  fromJSONC = text: builtins.fromJSON (strip text);
  readFile = path: builtins.fromJSON (strip (builtins.readFile path));
}
