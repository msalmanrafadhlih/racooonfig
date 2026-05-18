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
    (symlinkJoin {
      name = "rofi-webp-support";
      paths = [ rofi ]; 
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/rofi \
          --prefix GDK_PIXBUF_MODULE_FILE : "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
          --set GDK_PIXBUF_MODULEDIR "${webp-pixbuf-loader}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
      '';
    })
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
