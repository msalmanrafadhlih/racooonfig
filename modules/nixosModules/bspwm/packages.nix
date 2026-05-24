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
    environment.systemPackages = [
      inp.plank-reloaded.packages.${system}.default
    ]

    ++ (with pkgs; [
      # ======== BSPWM Stuff
      bsp-layout
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
      redshift
      pamixer
      dunst
      maim
      lsof
      feh
      bc

      # ======== X UTILS
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

      # ======== GTK engine
      nwg-look
      glib

      # tray
      wmctrl # ../../../configs/bspwm/bin/WindowSwitcher
      kdocker
      # zscroll # ../../../configs/bspwm/rices/tokyoNight/scripts/scroll-spotify
    ]);
  };
}
