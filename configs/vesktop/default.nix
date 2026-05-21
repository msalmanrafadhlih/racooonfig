{
  mkSymlink,
  lib,
  config,
  ...
}:

let
  cfg = config.racooonfig;
  configs = {
    "vesktop/themes" = "themes";
  };
in
{
  config = lib.mkIf (builtins.elem "vesktop" cfg.listConfigurations) {
    xdg.configFile = mkSymlink {
      target = "vesktop";
    } configs;
  };
}
