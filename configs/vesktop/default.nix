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
    "vesktop/themes" = "themes";
  };
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "vesktop" cfg.listConfigurations) {
    home.packages = [ pkgs.vesktop ];
    xdg.configFile = mkSymlink {
      target = "vesktop";
    } configs;
  };
}
