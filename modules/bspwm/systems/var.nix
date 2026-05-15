{ ... }:

{
  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "bspwm";
      XDG_SESSION_TYPE = "x11";
    };

    extraInit = ''
      export XCURSOR_PATH="/usr/share/icons''${XCURSOR_PATH:+:$XCURSOR_PATH}"
      export XDG_DATA_DIRS="/usr/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"

      if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
        eval $(dbus-launch --sh-syntax --exit-with-session)
    '';
  };

  systemd.tmpfiles.rules = [
    "d /usr/share/icons 0775 root wheel -"
    "d /usr/share/themes 0775 root wheel -"
  ];
}
