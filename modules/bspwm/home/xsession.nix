# ./modules/xsession.nix
{
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

  		mpDris2 &

  		# disable keyboard internal
      xinput disable "AT Translated Set 2 keyboard"
    '';
  };
}
