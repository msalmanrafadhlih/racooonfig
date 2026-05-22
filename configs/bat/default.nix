{
  mkSymlink,
  lib,
  config,
  ...
}:
let
  configs = {
    config = "bat/config";
  };

  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "bat" cfg.listConfigurations) {

    xdg.configFile = mkSymlink {
      target = "bat";
    } configs;
  };

}
