{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "cursor-memes";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "Cursors-memes";
    rev = "83f7dabd8c12d2b4d5c45666ec6d39b602c23be2";

    # WAJIB: Tambahkan ini agar Nix hanya mengambil folder tema tersebut
    sparseCheckout = [
      "Kafka"                           # red
      "Crelly-Cursor-Pack"              # green
      "Ju-Fufu"                         # yellow
      "Kiana"                           # grey
      "Ellen-Joe"                       # black
      "Erika-Furudo"                    # blue
      "Bibata-Modern-Ice"             
      "Skyrim-by-ru5tyshark-cursors"  
    ];

    sha256 = "sha256-8V2m3xDEFKETM9FECoZvqNxU5BBz5v+gf23mx1Cqr8c=";
  };

  installPhase = ''
    # Buat direktori tujuan standar kursor Linux
    mkdir -p $out/share/icons

    for d in *; do
      # Cek apakah itu direktori dan memiliki file index.theme di dalamnya
      if [ -d "$d" ] && [ -f "$d/index.theme" ]; then
        echo "Installing cursor pack: $d"
        cp -pr "$d" $out/share/icons/
      fi
    done

    # Opsional: Hapus folder 'default' jika tidak sengaja terikut 
    # agar tidak konflik dengan Stylix
    rm -rf $out/share/icons/default
  '';
}
