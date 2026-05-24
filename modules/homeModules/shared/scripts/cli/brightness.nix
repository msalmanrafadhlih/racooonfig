{
  pkgs,
  config,
  lib,
  ...
}:

let
  brightness-script = pkgs.writeShellApplication {
    name = "brightness";
    runtimeInputs = with pkgs; [
      brightnessctl
      dunst
    ];
    text = ''
      current=$(brightnessctl get)
      max=$(brightnessctl max)
      percent=$(( current * 100 / max ))
      icon="$HOME/.config/Assets/Icons/brightness.svg"

      case "$1" in
        --up) 
          brightnessctl set +1% 
          ;;
        --down)
          if [ "$percent" -gt 5 ]; then
            brightnessctl set 1%-
          fi
          ;;
      esac

      current=$(brightnessctl get)
      percent=$(( current * 100 / max ))

      dunstify -t 2000 -i "$icon" \
        -h int:value:"$percent" \
        -r 1001 \
        -u low "Brightness" "''${percent}%"
    '';
  };
in
{
  config = lib.mkIf config.racooonfig.homeManager {

    # Panggil skripnya di home.packages
    home.packages = [
      brightness-script
    ];
  };
}
