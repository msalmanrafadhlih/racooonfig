{ config, lib, pkgs, ... }:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (builtins.elem "geany" cfg.listConfigurations) {
    home.packages = with pkgs; [
      geany
    ];
  };
}
