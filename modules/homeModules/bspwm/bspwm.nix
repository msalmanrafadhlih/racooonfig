# ./modules/xsession.nix
{ config, lib, mkSymlink, ... }:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "bspwm" cfg.listConfigurations) {

    xdg = import ../../../configs/bspwm { inherit mkSymlink; };

    xsession = {
      windowManager.command = "bspwm";
    };
  };
}
