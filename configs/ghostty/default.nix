{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "ghostty" cfg.listConfigurations) {
    home.packages = with pkgs; [
      ghostty
    ];
  };
}
