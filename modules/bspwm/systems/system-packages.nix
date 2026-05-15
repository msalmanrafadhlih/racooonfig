{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  inp = inputs.racooonfig.inputs;
in
{
  environment.systemPackages =
    [
      inp.matugen.packages.${system}.default
      inp.plank-reloaded.packages.${system}.default
    ]
    ++ (with pkgs; [
      # ======== BSPWM Stuff
      polybarFull
      sxhkd
      picom
      rofi
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
      xclip
      dunst
      maim
      feh
      bc

      # ======== X UTILS
      (python3.withPackages (ps: with ps; [
        pywal
        colorthief
        haishoku
      ]))

      shared-mime-info
      imlib2
      xinit
      psmisc
      xsetroot
      xrandr
      xinput
      xdotool
      xcolor
      xdo
      xev
      xxHash

      # ======== GTK
      gtk2
      gtk3
      gtk4
      dconf
      dconf-editor

      # ======== GTK engine
      gtk-engine-murrine
      nwg-look
      glib

      # tray
      wmctrl
      snixembed
      libappindicator
      kdocker
    ]);
}
