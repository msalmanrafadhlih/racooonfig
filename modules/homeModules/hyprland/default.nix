# ./modules/xsession.nix
{ config, lib, mkSymlink, ... }:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "hyprland" cfg.listConfigurations) {

    xdg = import ../../../configs/hyprland { inherit mkSymlink; };

    home.sessionVariables = {
      BROWSER = "vivaldi";
      TERMINAL = "st";
      XCURSOR_SIZE = "24";

      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };
}
