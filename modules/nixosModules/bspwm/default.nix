{ lib, config, ... }:
let
  cfg = config.racooonfig;
in

{
  imports = [
    ./thunar.nix
    ./fonts.nix
    ./services.nix
    ./xdg-portal.nix
  ];

  config = lib.mkIf (cfg.enable && builtins.elem "bspwm" cfg.windowManager) {
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
    };
  };
}
