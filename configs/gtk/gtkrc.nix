{ config, ... }:
let
  HOME = config.home.homeDirectory;
in
{
  # Copy/symlink theme ke ~/.themes
  ".themes/dynamic/gtk-4.0/assets".source = ./.themes/gtk-4.0/assets;
  ".themes/dynamic/gtk-4.0/libadwaita.css".source = ./.themes/gtk-4.0/libadwaita.css;
  ".themes/dynamic/gtk-4.0/libadwaita-tweaks.css".source = ./.themes/gtk-4.0/libadwaita-tweaks.css;

  ".themes/dynamic/gtk-3.0".source = ./.themes/gtk-3.0;
  ".themes/dynamic/index.theme".source = ./.themes/index.theme;

  # gtk.css
  ".themes/dynamic/gtk-4.0/gtk.css".text = ''
    @import url("file://${HOME}/.config/gtk-4.0/gtk.css");
    @import url("libadwaita.css");
    @import url("libadwaita-tweaks.css");
  '';

  ".themes/dynamic/gtk-4.0/gtk-dark.css".text = ''
    @import url("file://${HOME}/.config/gtk-4.0/colors.css");
    @import url("libadwaita.css");
    @import url("libadwaita-tweaks.css");
  '';

  ".gtkrc-2.0" = {
    text = ''
      # DO NOT EDIT! This file will be overwritten by nwg-look.
      # Any customization should be done in ~/.gtkrc-2.0.mine instead.

      include "${HOME}/.gtkrc-2.0.mine"
      gtk-theme-name="adwaita"
      gtk-icon-theme-name="adwaita"
      gtk-font-name="Adwaita Sans 11"
      gtk-cursor-theme-name="adwaita"
      gtk-cursor-theme-size=24
      gtk-toolbar-style=GTK_TOOLBAR_ICONS
      gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      gtk-button-images=0
      gtk-menu-images=0
      gtk-enable-event-sounds=1
      gtk-enable-input-feedback-sounds=1
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
  };
}
