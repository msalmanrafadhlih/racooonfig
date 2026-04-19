{ inputs, pkgs, ... }:
let
  inp = inputs.racooonfig.inputs;
in
{
  imports = [
    ./system-packages.nix
    ./services.nix
    ./xdg-portal.nix
    ./thunar.nix
    # ../../../configs/stylix
  ];

  environment.systemPackages = [
    inp.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.qylock-sddm-theme
  ];

  services = {
    xserver = {
      enable = true;
      windowManager = {
        bspwm.enable = true;
      };
      autoRepeatDelay = 300;
      autoRepeatInterval = 35;
      displayManager = {
        startx.enable = false; # disable if set lightdm to true
        # lightdm
        lightdm = {
          enable = false;
          background = builtins.fetchurl {
            url = "https://raw.githubusercontent.com/msalmanrafadhlih/Nixos-Dotsfile/refs/heads/main/config/Assets/Wallpaper/wallpaper8.jpeg";
            sha256 = "sha256-VZp1wy2N0GApt48ILRY+pIAhAjCt02GmqmxHRTWAEoA=";
          };
        };
      };
    };

    displayManager = {
      # SDDM
      sddm = {
        enable = true;
        theme = "R1999_2";

        # PENTING: SDDM butuh ini agar module QML terbaca oleh greeter
        # Tambahkan paket tema dan dependensi QML yang wajib
        extraPackages = [
          pkgs.kdePackages.qtmultimedia
          pkgs.kdePackages.qt5compat
          pkgs.kdePackages.qtsvg
          pkgs.kdePackages.qtdeclarative # qt6-declarative di dokumen

          # GStreamer Plugins (Wajib untuk video background di qylock)
          pkgs.gst_all_1.gst-plugins-base
          pkgs.gst_all_1.gst-plugins-good
          pkgs.gst_all_1.gst-plugins-bad
          pkgs.gst_all_1.gst-plugins-ugly
          pkgs.gst_all_1.gst-libav
        ];
      };
    };
  };

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "bspwm";
    XDG_SESSION_TYPE = "x11";
  };
}
