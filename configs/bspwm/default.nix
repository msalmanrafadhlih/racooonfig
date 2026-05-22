# ./bspwm/default.nix
{
  mkSymlink,
  config,
  lib,
  ...
}:

let
  cfg = config.racooonfig;

  configs = {
    polybar = "polybar";
    picom = "picom";
    sxhkd = "sxhkd";
    dunst = "dunst";
    rofi = "rofi";
    eww = "eww";

    "bspwm/bin" = "bin";
    "bspwm/rices" = "rices";
    "bspwm/bspwmrc" = "bspwmrc";
    "bspwm/.term" = "var/.term";
    "bspwm/.rice" = "var/.rice";
  };
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "bspwm" cfg.listConfigurations) {
    xdg.configFile = mkSymlink {
      target = "bspwm";
    } configs;
  };
}
