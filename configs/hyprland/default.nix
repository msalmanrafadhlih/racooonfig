# ./bspwm/default.nix
{
  mkSymlink,
  ...
}:

let
  configs = {
    "Hyprland/rices"     = "rices";
    "hypr/config"        = "config";
    "hypr/scripts"       = "scripts";
    "hypr/.luarc.json"   = ".luarc.json";
    "hypr/hyprland.lua"  = "hyprland.lua";
    "hyhl.meta.lua"      = "hl.meta.lua";
  };
in
{
  configFile = mkSymlink {
    target = "hyprland";
  } configs;
}
