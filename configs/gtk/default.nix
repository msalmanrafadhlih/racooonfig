{ pkgs, mkSymlink, ... }: let

  configs = {
   "qt5ct/qt5ct.conf" = "qt5ct.conf";
   "qt6ct/qt6ct.conf" = "qt6ct.conf";
  };

in {

  # Install assets (cursor, icon, theme)
  home.packages = with pkgs; [
    # Icons  
    vimix-icon-theme

    # Cursors
    cursor-memes

    # themes
    adwaita-qt
    omni-gtk-theme
    vimix-gtk-themes

    gsettings-desktop-schemas
  ];

  # Cursor fallback global
  home.pointerCursor = {
    name = "Kafka";
    package = pkgs.cursor-memes;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Home variables
  home.sessionVariables = {
    XCURSOR_THEME = "Kafka";
    XCURSOR_SIZE = "24";

    GTK_THEME = "Adwaita:dark";

    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  # QT config (biar ikut icon/theme)
  xdg.configFile = mkSymlink {
    target = "qt";
  } configs;

  # ✅ Pastikan schema tersedia
  xdg.systemDirs.data = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];
}


