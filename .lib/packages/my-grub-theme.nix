{ stdenv, fetchFromGitHub }:
let
  selectedTheme = "sayonara";
in
stdenv.mkDerivation {
  pname = "my-custom-grub-theme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "MyGrubThemes";
    rev = "41338c9dc899b14cef9bb4530ef9bd5560ae2b64";

    # WAJIB: Tambahkan ini agar Nix hanya mengambil folder tema tersebut
    sparseCheckout = [ selectedTheme ];

    sha256 = "sha256-F2ehvobYRadrHIbS2et/N5uQvv9iIZiJ+x/ggRLrTE4=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ${selectedTheme}/* $out/
  '';
}
