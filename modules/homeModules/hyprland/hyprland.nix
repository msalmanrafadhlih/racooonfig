# ./modules/xsession.nix
{
  config,
  lib,
  mkSymlink,
  pkgs,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "hyprland" cfg.listConfigurations) {
    wayland.windowManager.hyprland.enable = true;
    services.easyeffects.enable = true;  
    xdg = import ../../../configs/hyprland { inherit mkSymlink; };

    services.swayosd = {
      enable = true;
      topMargin = 0.9;
      stylePath = "${config.home.homeDirectory}/.config/swayosd/style.css";
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      hypr           = "${config.home.homeDirectory}/.dotfiles/racooonfig/configs/hyprland/";
      programs       = "${config.home.homeDirectory}/.dotfiles/racooonfig/configs";
    };

    home.activation.copyHyprConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.rsync}/bin/rsync -a --update ${config.home.homeDirectory}/.dotfiles/configs/hyprland/config/ $HOME/.config/hypr/config/
        chmod -R u+w $HOME/.config/hypr/config
    '';

    home.activation.copyHyprTemplates = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.rsync}/bin/rsync -a --update ${config.home.homeDirectory}/.dotfiles/configs/hyprland/templates/ $HOME/.config/hypr/templates/
        chmod -R u+w $HOME/.config/hypr/templates
    '';

    programs.zsh.initContent = lib.mkAfter (builtins.readFile ./init-zsh.sh);
  };
}
