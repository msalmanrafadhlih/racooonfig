{
  stylix = {
    enable = false;
    targets = {
      spicetify.enable = true;
      helix.enable = false;
      zellij.enable = false;
      starship.enable = false;
      zed.enable = false;
      tmux.enable = false;
    };
  };

  imports = [
    ./gtk.nix
  ];
}
