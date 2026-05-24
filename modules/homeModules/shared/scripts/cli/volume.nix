{
  pkgs,
  config,
  lib,
  ...
}:

let
  volume-script = pkgs.writeShellApplication {
    name = "set-volume";
    runtimeInputs = with pkgs; [
      pamixer
      dunst
    ];
    text = ''
      case "$1" in
        --inc) pamixer -i 1 ;;
        --dec) pamixer -d 1 ;;
        --toggle) pamixer -t ;;
      esac

      vol=$(pamixer --get-volume)
      mute=$(pamixer --get-mute)
      iconmute="$HOME/.config/Assets/Icons/mute.png"
      iconvol="$HOME/.config/Assets/Icons/vol.png"

      if [ "$mute" = "true" ]; then
        dunstify -t 2000 -i "$iconmute" -r 1002 -u low "Volume" "Muted"
      else
        dunstify -t 2000 -i "$iconvol" \
          -h int:value:"$vol" \
          -r 1002 \
          -u low "Volume" "''${vol}%"
      fi
    '';
  };
in
{
  config = lib.mkIf config.racooonfig.homeManager {

    home.packages = [
      volume-script
    ];
  };
}
