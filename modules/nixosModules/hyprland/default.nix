{ lib, config, ... }:
let
  cfg = config.racooonfig;

in

{
  config = lib.mkIf (cfg.enable && builtins.elem "hyprland" cfg.windowManager) {
    programs.hyprland.enable = true; 

    nix.settings = {
      substituters         = lib.mkAfter [ "https://hyprland.cachix.org" ];
      trusted-substituters = lib.mkAfter [ "https://hyprland.cachix.org" ];
      trusted-public-keys  = lib.mkAfter [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}
