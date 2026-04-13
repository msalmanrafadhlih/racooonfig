{ inputs, ... }:

{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  stylix = {
    targets = {
      spicetify.enable = true;
      helix.enable = false;
      zellij.enable = false;
      starship.enable = false;
      zed.enable = false;
      tmux.enable = false;
    };
  };
}
