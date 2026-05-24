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
  };
in
{
  configFile = mkSymlink {
    target = "hyprland";
  } configs;
}
