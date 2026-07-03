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
    mapAll ./plasma [ ] { }
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
      "d /srv/share 3775 root users -"
    ]
    ++ (map (dir: "d /srv/share/${dir} 2775 root users -") [
      "files" "fonts" "icons" "themes"
      "plasma" "wallpapers" "kwin"
      "aurorae" "color-schemes"
    ]);
  };
}
