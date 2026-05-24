# ./modules/xsession.nix
{ config, lib, ... }:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf cfg.homeManager {
    home.sessionVariables = {
      BROWSER = "vivaldi";
      TERMINAL = "st";
      XCURSOR_SIZE = "24";
    };

    xsession = {
      enable = true;
      # Tambahan script sebelum menjalankan WM (setara isi .xinitrc)
      initExtra = ''
            [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
            xsetroot -cursor_name left_ptr	    

            if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
                eval "$(dbus-launch --sh-syntax --exit-with-session)"
            fi

        		mpDris2 &

        		# disable keyboard internal
            # xinput disable "AT Translated Set 2 keyboard"
      '';
    };
  };
}
