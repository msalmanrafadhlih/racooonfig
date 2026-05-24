{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.racooonfig;
  mapFile = inputs.racooonfig.mapFile;
  mapAll = inputs.racooonfig.mapAll;
in
{
  imports =
    mapFile    ./bspwm    [ ] { }
    ++ mapFile ./hyprland [ ] { }
    ++ mapFile ./niri     [ ] { }
    ++ mapAll  ./shared   [ ] { };

  config = lib.mkIf cfg.enable {
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
  };
}
