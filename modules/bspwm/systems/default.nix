{ pkgs,  ... }:
{
  imports = [
    ./system-packages.nix
    ./services.nix
    ./xdg-portal.nix
    ./var.nix
    ./thunar.nix
    ./fonts.nix
    # ../../../configs/stylix
  ];

  environment.systemPackages = [
    pkgs.qylock-sddm-theme
    pkgs.cursor-memes
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
        theme = "orbital";
        setupScript = ''
          ${pkgs.xrdb}/bin/xrdb -merge - <<EOF
          Xcursor.theme: Skyrim-by-ru5tyshark-cursors
          Xcursor.size: 32
          EOF
        '';

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
}
