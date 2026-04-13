{ inputs, pkgs, ... }:
let
  inp = inputs.racooonfig.inputs;
in
{

  imports = [
    inp.matugen.nixosModules.default
  ];
  
  programs.matugen = {
    ###################################
    # 🔹 1. Enable
    ###################################
    enable = true;

    ###################################
    # 🔹 2. Package Override (optional)
    ###################################
    package = pkgs.matugen;

    ###################################
    # 🎨 3. Source Warna
    ###################################

    # Pilih SALAH SATU:

    ## A. Pakai warna manual
    # source_color = "#ff1243";

    ## B. Pakai wallpaper (default)
    wallpaper = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/msalmanrafadhlih/racooonfig/refs/heads/main/configs/Assets/Wallpaper/wallpaper8.jpeg";
      sha256 = "sha256-VZp1wy2N0GApt48ILRY+pIAhAjCt02GmqmxHRTWAEoA=";
    };

    ###################################
    # 🎭 4. Palette Type
    ###################################
    type = "scheme-tonal-spot";
    # opsi lain:
    # "scheme-content"
    # "scheme-expressive"
    # "scheme-fidelity"
    # "scheme-fruit-salad"
    # "scheme-monochrome"
    # "scheme-neutral"
    # "scheme-rainbow"
    # "scheme-vibrant"

    ###################################
    # 🌗 5. Variant
    ###################################
    variant = "dark";
    # "light"
    # "dark"
    # "amoled"

    ###################################
    # 🎚️ 6. Contrast
    ###################################
    contrast = 0.0; # range: -1.0 → 1.0

    ###################################
    # 🌑 7. Lightness Tuning
    ###################################
    lightness_dark = 0.0;
    lightness_light = 0.0;

    ###################################
    # 🎯 8. Source Color Index (wallpaper)
    ###################################
    source_color_index = 0;
    # 0 = dominant
    # 1-4 = warna alternatif

    ###################################
    # 🧾 9. JSON Format
    ###################################
    jsonFormat = "strip";
    # opsi:
    # "rgb"
    # "rgba"
    # "hsl"
    # "hsla"
    # "hex"
    # "strip"

    ###################################
    # 🎨 10. Custom Colors
    ###################################
    custom_colors = {
      red = {
        color = "#ff0000";
        blend = false;
      };

      accent = {
        color = "#00ffcc";
        blend = true;
      };
    };

    config = ''

      [templates.gtk]
      input_path = "~/.config/templates/gtk-colors.css"
      output_path = "~/.config/gtk-3.0/colors.css"

      [templates.vivaldi]
      input_path = "~/.config/templates/vivaldi.css"
      output_path = "~/.config/vivaldi/CustomCSS/colors.css"

    '';

  };
}
