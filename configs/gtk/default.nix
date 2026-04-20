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

  # ✅ Pastikan schema tersedia
  xdg.systemDirs.data = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];
}


