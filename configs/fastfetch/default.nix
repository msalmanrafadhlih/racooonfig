{
  mkSymlink,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.racooonfig;
  configs = {
    "fastfetch/config.jsonc" = "config.jsonc";

    "fastfetch/ascii" = "ascii";
    "fastfetch/gifs" = "gifs";
    "fastfetch/pngs" = "pngs";
  };
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
