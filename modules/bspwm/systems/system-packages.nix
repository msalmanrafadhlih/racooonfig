{ pkgs, ... }:
{
  programs.dconf.enable = true; 

  environment.systemPackages = with pkgs; [
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
    wallust # better Pywal : Color generator
    pamixer
    xclip # Clipboard
    dunst
	  kdocker
		qview
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
    xev # key(board) mapping

    # ======== GTK
    gtk2 # Tambahkan ini
    gtk3
    gtk4
    
    # ======== GTK engine
    gsettings-desktop-schemas
    gtk-engine-murrine
    nwg-look
    glib # gsettings CLI
  ];
}
