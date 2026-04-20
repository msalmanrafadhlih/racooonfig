# ./bspwm/default.nix
{ mkSymlink, ... }:

let
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
		"bspwm/.term" = ".term";
		"bspwm/.rice" = ".rice";
  };
in {
  xdg.configFile = mkSymlink {
    target = "bspwm";
  } configs; 
}
