{
  mkSymlink,
  lib,
  config,
  ...
}:

let
  configs = {
    "com.kdocker/icons" = "icons";
    "com.kdocker/KDocker.conf" = "KDocker.conf";
  };
  cfg = config.racooonfig;
in

{
  config = lib.mkIf (cfg.homeManager && builtins.elem "bspwm" cfg.listConfigurations) {};
    xdg.configFile = mkSymlink {
      target = "com.kdocker";
    } configs;
  };

}
