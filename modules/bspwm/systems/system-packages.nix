{ pkgs, inputs, ... }:
let
  inp = inputs.racooonfig.inputs;
in
{
  environment.systemPackages = [
    inp.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    inp.plank-reloaded.defaultPackage.${pkgs.stdenv.hostPlatform.system}

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
    qview
    pywal
    maim
    feh
    bc

    # ======== X UTILS
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
    snixembed
    libappindicator
    kdocker
  ]);
}
