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

    displayManager = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        enable display manager 
      '';
    };

    steam = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        enable steam programs
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
