{ lib, ... }:
{
  imports = [ ./starter.nix ];

  options.racooonfig = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        enable system configurations for racooonfig 
      '';
    };

    enableDisplayManager = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        enable display manager configurations
      '';
    };

    windowManager = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [ "bspwm" "hyprland" "niri" ]
      );
      default = [ ];
      description = ''
        List of enabled window managers
      '';
    };
  };
}
