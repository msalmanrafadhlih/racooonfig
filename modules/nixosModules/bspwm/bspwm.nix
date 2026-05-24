{ lib, config, ... }:
let
  cfg = config.racooonfig;
in

{
  config = lib.mkIf (cfg.enable && builtins.elem "bspwm" cfg.windowManager) {

    security.pam.services.i3lock.enable = true;
    security.pam.services.i3lock = { };
    security.pam.services.i3lock.text = ''
      		auth include login
      	'';

    services = {
      xserver = {
        enable = true;
        windowManager = {
          bspwm.enable = true;
        };
        # desktopManager.xterm.enable = false;
        # excludePackages = [ pkgs.xterm ];
        autoRepeatDelay = 300;
        autoRepeatInterval = 35;
      };
    };
  };
}
