{
  lib,
  inputs,
  config,
  ...
}:
let
  mapFile = inputs.racooonfig.mapFile;
  mapDir  = inputs.racooonfig.mapDir;
  cfg     = config.racooonfig;

  bspwm    = mapFile ./nixosModules/bspwm [ ] { };
  hyprland = mapFile ./nixosModules/hyprland [ ] { };
  niri     = mapFile ./nixosModules/niri [ ] { };
  home     = [ ./homeModules/default.nix ];
in
{
  imports =
    lib.optional cfg.enable ./nixosModules/default.nix
    ++ lib.optionals (cfg.enable && builtins.elem "bspwm" cfg.windowManager) bspwm
    ++ lib.optionals (cfg.enable && builtins.elem "hyprland" cfg.windowManager) hyprland
    ++ lib.optionals (cfg.enable && builtins.elem "niri" cfg.windowManager) niri
    ++ mapDir ../configs [ "bspwm" "hyprland" "niri" ] { }
    ++ home;
}
