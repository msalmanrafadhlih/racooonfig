# ./bspwm/default.nix
{
  mkSymlink,
  ...
}:

let
  configs = {
    "hyprland/rices" = "rices";
  };
in
{
  configFile = mkSymlink {
    target = "hyprland";
  } configs;
}
