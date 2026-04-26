{ pkgs, config, mkSymlink, ... }:

let
  HOME = config.home.homeDirectory;
  configs = {
    "gtk-3.0/settings.ini" = "settings.ini";
    "gtk-4.0/settings.ini" = "settings.ini";
  };
in {
  home.packages = with pkgs; [
    vimix-icon-theme
    cursor-memes
    vimix-gtk-themes
  ];

  xdg.configFile = mkSymlink {
    target = "gtk";
  } configs;

  # Copy/symlink theme ke ~/.themes
  home.file.".gtkrc-2.0".source = ./gtkrc-2.0;

  home.file.".themes/dynamic/gtk-4.0/assets".source = ./.themes/gtk-4.0/assets;
  home.file.".themes/dynamic/gtk-4.0/libadwaita.css".source = ./.themes/gtk-4.0/libadwaita.css;
  home.file.".themes/dynamic/gtk-4.0/libadwaita-tweaks.css".source = ./.themes/gtk-4.0/libadwaita-tweaks.css;

  home.file.".themes/dynamic/gtk-3.0".source = ./.themes/gtk-3.0;
  home.file.".themes/dynamic/index.theme".source = ./.themes/index.theme;

  # gtk.css
  home.file.".themes/dynamic/gtk-4.0/gtk.css".text = ''
    @import url("file://${HOME}/.config/gtk-4.0/colors.css");
    @import url("libadwaita.css");
    @import url("libadwaita-tweaks.css");
  '';

  home.file.".themes/dynamic/gtk-4.0/gtk-dark.css".text = ''
    @import url("file://${HOME}/.config/gtk-4.0/colors.css");
    @import url("libadwaita.css");
    @import url("libadwaita-tweaks.css");
  '';
}
