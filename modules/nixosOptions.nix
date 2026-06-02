{ lib, ... }:
{
  imports = [ ./nixosModules ];

  options.racooonfig = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable racooonfig system configurations";
    };

    displayManager = lib.mkOption {
      type = lib.types.enum [
        "sddm"
        "lightdm"
      ];
      default = "";
      description = "Which display manager to use";
    };

    windowManager = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          # Window Manager
          "hyprland"
          "bspwm"
          "niri"
          "qtile"
        ]
      );
      default = [ ];
      description = "List of enabled window managers";
    };

    desktopManager = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          # deskop Environment
          "plasma"
          "gnome"
        ]
      );
      default = [ ];
      description = "List of enabled window managers";
    };

    fileManager = lib.mkOption {
      type = lib.types.enum [
        "dolphin"
        "thunar"
      ];
      default = "";
      description = "Which display manager to use";
    };

    gamemode = lib.mkOption {
      default = { };
      description = "Gamemode configuration";
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable gamemode";
          };
          programs = lib.mkOption {
            type = lib.types.listOf (
              lib.types.enum [
                "steam"
              ]
            );
            default = [ ];
            description = "List of game-related programs to enable";
          };
        };
      };
    };
  };
}
