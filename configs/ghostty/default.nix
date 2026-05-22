{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.racoonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "ghostty" cfg.listConfigurations) {
    home.packages = with pkgs; [
      ghostty
    ];
  };
}
