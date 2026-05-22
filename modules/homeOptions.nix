{ inputs, lib, ... }:
let
  # mapAll = inputs.racooonfig.mapDir;
in
{
  imports = [
    ./homeModules

    ../configs/matugen
    ../configs/suckless
    ../configs/vesktop
    ../configs/xytz
    ../configs/com.kdocker
    ../configs/rmpc
    ../configs/qt
    ../configs/kitty
    ../configs/code
    ../configs/spotify
    ../configs/mpd
    ../configs/gemini
    ../configs/inlyne
    ../configs/alacritty
    ../configs/Apps
    ../configs/nwg-drawer
    ../configs/rclone
    ../configs/zen-browser
    ../configs/gtk
    ../configs/nano
    ../configs/yazelix
    ../configs/ncmpcpp
    ../configs/firefox
    ../configs/fastfetch
    ../configs/geany
    ../configs/ghostty
    ../configs/zathura
    ../configs/zed-editor
    ../configs/bat
    ../configs/btm
  ];

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
