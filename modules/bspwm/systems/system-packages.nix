{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  inp = inputs.racooonfig.inputs;
in
{
  environment.systemPackages = [
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
    dunst
    maim
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
  ]);
}
