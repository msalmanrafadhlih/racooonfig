{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.racooonfig;
  mapAll = inputs.racooonfig.mapAll;
in
{
  imports = [
    ./plasma
  ]
  ++ mapAll ./hyprland [ ] { }
  ++ mapAll ./bspwm [ ] { }
  ++ mapAll ./niri [ ] { }
  ++ mapAll ./shared [ ] { };

  config = lib.mkIf cfg.enable {
    environment = {
      extraInit = ''
        export XCURSOR_PATH="/srv/share/icons:/usr/share/icons''${XCURSOR_PATH:+:$XCURSOR_PATH}"
        export XDG_DATA_DIRS="/srv/share:/usr/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      '';
    };

    systemd.tmpfiles.rules = [
      "d /srv/share            0755 root users -"
      "d /srv/share/wallpapers 2775 root users -"
      "d /srv/share/music      2775 root users -"
      "d /srv/share/files      2775 root users -"
      "d /srv/share/icons      2775 root users -"
      "d /srv/share/themes     2775 root users -"
    ];
  };
}
