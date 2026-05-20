{ stdenv, fetchFromGitHub }:

let
  selectedTheme = "clockwork";
  themeSubPath = "themes/${selectedTheme}";
in
stdenv.mkDerivation {
  pname = "qylock-sddm-theme-${selectedTheme}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "qylock";
    rev = "ca5bd56cbe587f4f115be439d4a120f2721224a6";
    sparseCheckout = [ themeSubPath ];
    sha256 = "sha256-bX1jo+4xgh5Jgtjqk82G2b3jMkeMvIiAIk4ICWOtLq0=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sddm/themes

    copy_theme() {
      local dir="$1"

      if [ -f "$dir/metadata.desktop" ] && [ -f "$dir/theme.conf" ]; then
        local name
        name="$(basename "$dir")"

        echo "Installing SDDM theme: $name"

        cp -r "$dir" "$out/share/sddm/themes/$name"
        
        # Pastikan permission-nya benar agar bisa dibaca SDDM
        chmod -R 755 "$out/share/sddm/themes/$name"
      fi
    }

    copy_theme "${themeSubPath}"

    # Cek subfolder
    for dir in ${themeSubPath}/*; do
      [ -d "$dir" ] || continue
      copy_theme "$dir"
    done

    runHook postInstall
  '';
}
