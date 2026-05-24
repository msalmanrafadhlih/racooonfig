# ./bspwm/default.nix
{
  mkSymlink,
  ...
}:

let
  configs = {
    "Hyprland/rices"     = "rices";
    "hypr/scripts"       = "scripts";
    "hypr/hyprland.conf" = "hyprland.conf";
    "hypr/config"        = "config";
  };
in
{
  configFile = mkSymlink {
    target = "hyprland";
  } configs;
}
