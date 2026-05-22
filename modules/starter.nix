{
  lib,
  inputs,
  config,
  ...
}:
let
  mapDir = inputs.racooonfig.mapDir;
  cfg = config.racooonfig;
in
{
  imports =
    lib.optionals cfg.enable [ ./nixosModules/default.nix ]
    ++ lib.optionals cfg.homeManager [ ./homeModules/default.nix ]
    ++ lib.optionals (cfg.enable && builtins.elem "bspwm" cfg.windowManager) [ ./nixosModules/bspwm ]
    ++ lib.optionals (cfg.enable && builtins.elem "hyprland" cfg.windowManager) [ ./nixosModules/hyprland ]
    ++ lib.optionals (cfg.enable && builtins.elem "niri" cfg.windowManager) [ ./nixosModules/niri ]
    ++ lib.optionals (builtins.elem "niri" cfg.listConfigurations) [ ./homeModules/bspwm ]
    ++ lib.optionals (builtins.elem "hyprland" cfg.listConfigurations) [ ./homeModules/hyprland ]
    ++ lib.optionals (builtins.elem "niri" cfg.listConfigurations) [ ./homeModules/niri ]
    ++ mapDir ../configs [ "bspwm" "hyprland" "niri" ] { };
}
