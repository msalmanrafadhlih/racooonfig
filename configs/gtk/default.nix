{ pkgs, mkSymlink, ... }: let

  configs = {
   "qt5ct/qt5ct.conf" = "qt/qt5ct.conf";
   "qt6ct/qt6ct.conf" = "qt/qt6ct.conf";
  };

in {

  # Install assets (cursor, icon, theme)
  home.packages = with pkgs; [
    # Icons & Cursors
    vimix-icon-theme
    cursor-memes

    adwaita-qt
    gsettings-desktop-schemas
  ];

  # GTK baseline (default)
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Vimix-ruby-dark";
      package = pkgs.vimix-icon-theme;
    };

    cursorTheme = {
      name = "Kafka";
      package = pkgs.cursor-memes;
      size = 24;
    };
  };

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
  xdg.configFile = mkSymlink {} configs;

  # ✅ Pastikan schema tersedia
  xdg.systemDirs.data = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];
}


