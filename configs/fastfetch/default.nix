{ mkSymlink, pkgs, ... }:
let
  configs = {
		"fastfetch/config.jsonc" = "config.jsonc";

		"fastfetch/ascii" = "ascii";
		"fastfetch/gifs" = "gifs";
		"fastfetch/pngs" = "pngs";
  };
in
{
  xdg.configFile = mkSymlink {
    target = "fastfetch";
  } configs;

  home.packages = with pkgs; [
    fastfetch
  ];
}
