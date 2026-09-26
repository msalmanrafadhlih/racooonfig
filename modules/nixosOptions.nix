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
      type = lib.types.nullOr (
        lib.types.enum [
          "sddm"
          "lightdm"
        ]
      );
      default = null;
      description = "Display manager to use";
    };

    windowManager = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
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
          "plasma"
          "gnome"
        ]
      );
      default = [ ];
      description = "List of enabled desktop managers";
    };

    fileManager = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "nautilus"
          "dolphin"
          "thunar"
        ]
      );
      default = null;
      description = "File manager to use";
    };

    gamemode = lib.mkOption {
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
                "waydroid"
              ]
            );
            default = [ ];
            description = "List of game-related programs to enable";
          };
        };
      };

      default = { };
      description = "Gamemode configuration";
    };
  };
}
