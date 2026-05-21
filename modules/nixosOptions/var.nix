{ ... }:

{
  environment = {
    extraInit = ''
      export XCURSOR_PATH="/usr/share/icons''${XCURSOR_PATH:+:$XCURSOR_PATH}"
      export XDG_DATA_DIRS="/usr/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
    '';
  };

  systemd.tmpfiles.rules = [
    "d /usr/share/icons 0775 root wheel -"
    "d /usr/share/themes 0775 root wheel -"
  ];
}
