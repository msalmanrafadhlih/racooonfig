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

		"bspwm/src" = "src";
		"bspwm/bspwmrc" = "bspwmrc";
  };
in {
  xdg.configFile = mkSymlink {
    target = "bspwm";
  } configs; 
  
  #########################
  ### Polybar Integrations:
  # Hide - Unhide Polybar
  imports = [
    ./show-polybar.nix
    ./hide-polybar.nix
    ./xsession.nix
    ./picom.nix
  ];
}
