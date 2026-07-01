{ inputs, lib, ... }:
let
  mapAll = inputs.racooonfig.mapDir;
in
{
  imports = [ ./homeModules ]
    ++ mapAll ../configs [
      "bspwm"
      "hyprland"
      "niri"
      "zen-browser"
    ] { };

  options.racooonfig = {
    homeManager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        enable system configurations for racooonfig 
      '';
    };

    flatpak = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        enable flatpak configs
      '';
    };

    listConfigurations = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          # desktop Environment
          "macos-kdeplasma"

          # window manager Configs
          "bspwm"
          "hyprland"
          "niri"

          # Apps configs
          "alacritty"
          "bat"
          "beets"
          "cava"
          "vscode"
          "fastfetch"
          "firefox"
          "geany"
          "ghostty"
          "inlyne"
          "kitty"
          "gemini"
          "nano"
          "neovim"
          "ncmpcpp"
          "nwg-drawer"
          "nix-search"
          "mpd"
          "rclone"
          "rmpc"
          "st"
          "vesktop"
          "wezterm"
          "xytz"
          "zathura"
          "zed-editor"
          "zen-browser"

          # flatpak
          "zen-flatpak"
          "spotify-flatpak"
          "riff-flatpak"
          "whatsapp-flatpak"
          "zoom-flatpak"
          "amberol-flatpak"
          "blanket-flatpak"
          "spotube-flatpak"
          "motrix-flatpak"
          "audiotube-flatpak"
          "nocturne-flatpak"

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
