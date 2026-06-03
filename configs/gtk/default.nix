{ pkgs, config, lib, ... }: let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "bspwm" cfg.listConfigurations) {
    home.file = import ./gtkrc.nix { inherit config; };
    home.packages = with pkgs; [
      vimix-gtk-themes
      vimix-icon-theme
      cursor-memes
    ];
  };
}
