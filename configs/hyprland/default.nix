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
  };
in
{
  configFile = mkSymlink {
    target = "hyprland";
  } configs;
}
