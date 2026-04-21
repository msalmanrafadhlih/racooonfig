{ pkgs, ... }: let

in {
  # Install assets (cursor, icon, theme)
  home.packages = with pkgs; [
    # Icons  
    vimix-icon-theme

    # Cursors
    cursor-memes

    # themes
    vimix-gtk-themes
  ];
}


