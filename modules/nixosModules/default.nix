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
  imports =
       mapAll ./plasma   [ ] { }
    ++ mapAll ./hyprland [ ] { }
    ++ mapAll ./bspwm    [ ] { }
    ++ mapAll ./niri     [ ] { }
    ++ mapAll ./shared   [ ] { };

  config = lib.mkIf cfg.enable {
    environment = {
      extraInit = ''
        export XCURSOR_PATH="/srv/share/Icons:/usr/share/icons''${XCURSOR_PATH:+:$XCURSOR_PATH}"
        export XDG_DATA_DIRS="/srv/share:/usr/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
      '';
    };

    systemd.tmpfiles.rules = [
      "d /srv/share                    0755 root users -"
      "d /srv/share/Wallpapers         2775 root users -"
      "d /srv/share/Musics              2775 root users -"
      "d /srv/share/Files              2775 root users -"
      "d /srv/share/Icons              2775 root users -"
      "d /srv/share/Themes             2775 root users -"

      "d /srv/share/fonts              2775 root users -"
      "d /srv/share/plasma             2775 root users -"
      "d /srv/share/plasma/plasmoids   2775 root users -"
      "d /srv/share/plasma/wallpapers  2775 root users -"
      "d /srv/share/kwin               2775 root users -"
      "d /srv/share/aurorae            2775 root users -"
      "d /srv/share/color-schemes      2775 root users -"
    ];
  };
}
