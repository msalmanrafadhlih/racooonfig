{ pkgs, ... }: let

in {

  # Install assets (cursor, icon, theme)
  home.packages = with pkgs; [
    # Icons  
    vimix-icon-theme

    # Cursors
    cursor-memes

    # themes
    adwaita-qt
    adw-gtk3
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

    QT_QPA_PLATFORMTHEME = "qt5ct";

    # GTK_THEME = "";
    # QT_STYLE_OVERRIDE = "";
  };

  # ✅ Pastikan schema tersedia
  xdg.systemDirs.data = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];
}


