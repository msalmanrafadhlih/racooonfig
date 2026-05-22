{ lib, ... }:
{
  imports = [ ./nixosModules ];

  options.racooonfig = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        enable system configurations for racooonfig 
      '';
    };

    enableDisplayManager = lib.mkOption {
      type = lib.types.bool;
      default = true;
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
