{ lib, ... }:

{
  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "bspwm";
      XDG_SESSION_TYPE = "x11";
    };
    extraInit = ''
      if [ -f "$HOME/.dynamic" ]; then
        . "$HOME/.dynamic"
      fi
    '';
  };

  systemd.tmpfiles.rules = [
    # Menggunakan grup wheel agar hanya admin yang bisa memodifikasi
    "d /usr/share/icons 0775 root wheel -"
    "d /usr/share/themes 0775 root wheel -"
  ];

  environment.variables = {
    XCURSOR_PATH = lib.mkForce "/usr/share/icons:$HOME/.icons:$HOME/.local/share/icons";
    XDG_DATA_DIRS = [
      "/usr/share"
    ];
  };
}
