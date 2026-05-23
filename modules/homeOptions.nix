{ inputs, lib, ... }:
let
  mapAll = inputs.racooonfig.mapDir;
in
{
  imports = [ ./homeModules ]
      ++ mapAll ../configs [ "bspwm" "niri" "hyprland" "zen-browser" ] { };

  options.racooonfig = {

    homeManager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        enable system configurations for racooonfig 
      '';
    };

    listConfigurations = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [

          # window manager Configs
          "bspwm"
          "hyprland"
          "niri"

          # Apps configs
          "alacritty"
          "bat"
          "vscode"
          "fastfetch"
          "firefox"
          "geany"
          "ghostty"
          "inlyne"
          "kitty"
          "gemini"
          "nano"
          "ncmpcpp"
          "nwg-drawer"
          "mpd"
          "rclone"
          "rmpc"
          "spotify"
          "st"
          "vesktop"
          "xytz"
          "zathura"
          "zed-editor"
          "zen-browser"

          # enable program
          "gamemode"
        ]
      );
      default = [ ];
      description = ''
        List of configurations to use
      '';
    };
  };
}
