{ lib, ... }:
{
  imports = [ ./starter.nix ];

  options.racooonfig = {
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
          "bottom"
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
          "yazelix"
          "zathura"
          "zed-editor"
          "zen-browser"
        ]
      );
      default = [ ];
      description = ''
        List of configurations to use
      '';
    };
  };
}
