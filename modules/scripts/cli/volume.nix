{ pkgs, ... }:

let
  volume-script = pkgs.writeShellApplication {
    name = "set-volume";
    runtimeInputs = with pkgs; [ pamixer dunst ];
    text = ''
      case "$1" in
        --inc) pamixer -i 1 ;;
        --dec) pamixer -d 1 ;;
        --toggle) pamixer -t ;;
      esac

      vol=$(pamixer --get-volume)
      mute=$(pamixer --get-mute)

      if [ "$mute" = "true" ]; then
        dunstify -t 2000 -i audio-volume-muted-symbolic -r 1002 -u low "Volume" "Muted"
      else
        dunstify -t 2000 -i audio-volume-high-symbolic \
          -h int:value:"$vol" \
          -r 1002 \
          -u low "Volume" "''${vol}%"
      fi
    '';
  };
in
{
  home.packages = [
    volume-script
  ];
}
