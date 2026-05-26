# ./modules/xsession.nix
{
  config,
  lib,
  mkSymlink,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "hyprland" cfg.listConfigurations) {
    xdg = import ../../../configs/hyprland { inherit mkSymlink; };

    wayland.windowManager.hyprland = {
      enable = true;
      # configType = "lua";
    };

    services.swayosd = {
      enable = true;
      topMargin = 0.9;
      stylePath = "${config.home.homeDirectory}/.config/swayosd/style.css";
    };

    home.sessionVariables = {
      hypr = "${config.home.homeDirectory}/.dotfiles/racooonfig/configs/hyprland/";
      programs = "${config.home.homeDirectory}/.dotfiles/racooonfig/configs";
    };

    programs.zsh.initContent = lib.mkAfter (builtins.readFile ./init-zsh.sh);
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "quickshell -p ~/.config/hypr/scripts/quickshell/Lock.qml";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 900;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
