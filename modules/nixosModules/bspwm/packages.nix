{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  inp = inputs.racooonfig.inputs;
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.enable && builtins.elem "bspwm" cfg.windowManager) {

    programs.gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        cpu.park_cores = "no";
        general = {
          renice = 10;
          softrealtime = "auto";
        };
        custom.start = ''${pkgs.dunst}/bin/dunstify "GameMode" "enabled"'';
        custom.end = ''${pkgs.dunst}/bin/dunstify "GameMode" "disabled"'';
      };

    };

    environment.systemPackages = [
      inp.matugen.packages.${system}.default
      inp.plank-reloaded.packages.${system}.default
    ]

    ++ (with pkgs; [
      # ======== BSPWM Stuff
      polybarFull
      sxhkd
      picom
      eww
      i3lock-color

      # ======== TOOLS
      sound-theme-freedesktop
      libcanberra-gtk3
      mpv-unwrapped
      brightnessctl
      flameshot
      imagemagick
      clipmenu
      pamixer
      dunst
      maim
      lsof
      feh
      bc

      # ======== X UTILS
      (python3.withPackages (
        ps: with ps; [
          pywal
          haishoku
        ]
      ))

      shared-mime-info
      xinit
      xclip
      psmisc
      xsetroot
      xrandr
      xinput
      xdotool
      xcolor
      xdo
      xev
      xxHash # ../../../configs/bspwm/bin/WallSync
      calc

      # ======== GTK
      gtk2
      gtk3
      gtk4
      dconf
      dconf-editor

      # ======== GTK engine
      nwg-look
      glib

      # tray
      wmctrl # ../../../configs/bspwm/bin/WindowSwitcher
      kdocker
      zscroll # ../../../configs/bspwm/rices/tokyoNight/scripts/scroll-spotify
    ]);
  };
}
