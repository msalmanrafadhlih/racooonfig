{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.racooonfig;
  mapFile = inputs.racooonfig.mapFile;
in
{
  imports =  mapFile ./bspwm    [ ] { }
          ++ mapFile ./hyprland [ ] { }
          ++ mapFile ./niri     [ ] { };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment = {
        extraInit = ''
          export XCURSOR_PATH="/usr/share/icons''${XCURSOR_PATH:+:$XCURSOR_PATH}"
          export XDG_DATA_DIRS="/usr/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
        '';
      };

      systemd.tmpfiles.rules = [
        "d /usr/share/icons 0775 root wheel -"
        "d /usr/share/themes 0775 root wheel -"
      ];
    })
    (lib.mkIf (cfg.enable && cfg.enableDisplayManager) {
      environment.systemPackages = [
        pkgs.qylock-sddm-theme
        pkgs.cursor-memes
      ];
      services = {
        displayManager = {
          sddm = {
            enable = lib.mkDefault true;
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
  ];
}
