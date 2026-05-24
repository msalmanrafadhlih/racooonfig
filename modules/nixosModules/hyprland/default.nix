{ lib, config, pkgs, ... }:
let
  cfg = config.racooonfig;
in

{
  config = lib.mkIf (cfg.enable && builtins.elem "hyprland" cfg.windowManager) {
    environment.systemPackages = with pkgs; [
      hyprland
    ];
  };
}
