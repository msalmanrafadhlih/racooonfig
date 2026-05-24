{ lib, config, ... }:
let
  cfg = config.racooonfig;
in

{
  config = lib.mkIf (cfg.enable && builtins.elem "hyprland" cfg.windowManager) {
    programs.hyprland.enable = true;
    services.pipewire.enable = true;
  };
}
