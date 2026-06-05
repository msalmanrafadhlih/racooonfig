{
  mkSymlink,
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.racooonfig;
  configs = {
    "cava/config_base" = "config";
  };
in

{
  config = lib.mkIf (cfg.homeManager && builtins.elem "cava" cfg.listConfigurations) {
    home.packages = with pkgs; [
      cava
      qt6.qtwebsockets
    ];

    xdg.configFile = mkSymlink {
      target = "cava";
    } configs;
  };
}
