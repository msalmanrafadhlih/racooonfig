# ./bspwm/default.nix
{
  mkSymlink,
  ...
}:

let
  configs = {
    "Hyprland/rices" = "rices";
  };
in
{
  configFile = mkSymlink {
    target = "hyprland";
  } configs;
}
