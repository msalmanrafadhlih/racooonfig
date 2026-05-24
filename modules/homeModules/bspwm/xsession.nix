# ./modules/xsession.nix
{ config, lib, mkSymlink, ... }:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "bspwm" cfg.listConfigurations) {

    xdg = import ../../../configs/bspwm { inherit mkSymlink; };

    home.sessionVariables = {
      BROWSER = "vivaldi";
      TERMINAL = "st";
      XCURSOR_SIZE = "24";

      QT_QPA_PLATFORMTHEME = "qt5ct";
    };

    xsession = {
      enable = true;
      windowManager.command = "bspwm";

      # Tambahan script sebelum menjalankan WM (setara isi .xinitrc)
      initExtra = ''
            [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
            xsetroot -cursor_name left_ptr	    

            if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
                eval "$(dbus-launch --sh-syntax --exit-with-session)"
            fi

        		mpDris2 &

        		# disable keyboard internal
            xinput disable "AT Translated Set 2 keyboard"
      '';
    };
  };

}
