{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "ncmpcpp" cfg.listConfigurations) {

    home.packages = [ pkgs.ncmpcpp ];
  };
}
