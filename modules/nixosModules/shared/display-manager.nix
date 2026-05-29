{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf (cfg.displayManager == "sddm") {
        environment.systemPackages = [
          pkgs.qylock-sddm-theme
          pkgs.cursor-memes
        ];
        services = {
          displayManager = {
            sddm = {
              enable = lib.mkDefault true;
              wayland.enable =  false;
              theme = lib.mkDefault "orbital";
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
      })

      (lib.mkIf (cfg.displayManager == "lightdm") {
        services.xserver.displayManager = {
          startx.enable = false; # disable if set lightdm to true
          lightdm = {
            enable = lib.mkDefault true;
            background = builtins.fetchurl {
              url = "https://raw.githubusercontent.com/msalmanrafadhlih/Nixos-Dotsfile/refs/heads/main/config/Assets/Wallpaper/wallpaper8.jpeg";
              sha256 = "sha256-VZp1wy2N0GApt48ILRY+pIAhAjCt02GmqmxHRTWAEoA=";
            };
          };
        };
      })
    ]
  );
}
