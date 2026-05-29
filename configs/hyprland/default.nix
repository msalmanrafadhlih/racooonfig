# ./bspwm/default.nix
{
  mkSymlink,
  ...
}:

let
  configs = {
    "Hyprland/rices"     = "rices";
    "hypr/config"        = "config";
    "hypr/.luarc.json"   = ".luarc.json";
    "hypr/hyprland.lua"  = "hyprland.lua";
    "hypr/hl.meta.lua"   = "hl.meta.lua";

    "hypr/hyprland.conf" = "hyprland.conf";
    "hypr/backup"        = "oldconfig";
  };
in
{
  configFile = mkSymlink {
    target = "hyprland";
  } configs;
}
