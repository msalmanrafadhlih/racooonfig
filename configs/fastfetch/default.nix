{
  mkSymlink,
  pkgs,
  config,
  lib,
  ...
}:
let
  configs = {
    "fastfetch/config.jsonc" = "config.jsonc";

    "fastfetch/ascii" = "ascii";
    "fastfetch/gifs" = "gifs";
    "fastfetch/pngs" = "pngs";
  };
  cfg = config.racooonfig;
in
{

  config = lib.mkIf (cfg.homeManager && builtins.elem "fastfetch" cfg.listConfigurations) {
    xdg.configFile = mkSymlink {
      target = "fastfetch";
    } configs;

    home.packages = with pkgs; [
      fastfetch
    ];
  };

}
