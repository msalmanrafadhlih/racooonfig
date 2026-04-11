# source: https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/

{ ... }: {
  # catppuccin.gtk.icon = {
  #   enable = true;
  #   accent = "lavender";
  #   flavor = "mocha";
  # };

  gtk = {
    enable = true;
    gtk4.theme = null ;
    # theme = {
    #   package = pkgs.catppuccin-gtk.override {
    #     accents = [ "lavender" ];
    #     size = "standard";
    #     variant = "mocha";
    #   };
    #   name = "catppuccin-mocha-lavender-standard";
    # };

    # font = {
    #   name = "Open Sans";
    #   size = 10;
    # };
  };
}
