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
  config = lib.mkIf (builtins.elem "ncmpcpp" cfg.listConfigurations) {

    home.packages = [ pkgs.ncmpcpp ];
  };
}
