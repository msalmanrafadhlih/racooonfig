# ./modules/xsession.nix
{

  home.sessionVariables = {
    BROWSER = "vivaldi";
    TERMINAL = "st";
  };

  xsession = {
    enable = true;
    windowManager.command = "bspwm";

    # Tambahan script sebelum menjalankan WM (setara isi .xinitrc kamu)
    initExtra = ''
            [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
      	    eval "$(dbus-launch --sh-syntax)"
      	    export DBUS_SESSION_BUS_ADDRESS
            xsetroot -cursor_name left_ptr	    

        		mpDris2 &

        		# disable keyboard internal
            xinput disable "AT Translated Set 2 keyboard"
    '';
  };
  # export XCURSOR_THEME=Kafka
  # export XCURSOR_SIZE=14
  # xsetroot -cursor_name left_ptr
}
