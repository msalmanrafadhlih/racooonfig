{ pkgs, ... }:

let
  brightness-script = pkgs.writeShellApplication {
    name = "brightness";
    # Masukkan package yang dibutuhkan skrip di sini
    runtimeInputs = with pkgs; [ brightnessctl dunst ];
    text = ''
      current=$(brightnessctl get)
      max=$(brightnessctl max)
      percent=$(( current * 100 / max ))

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

      dunstify -t 2000 -i display-brightness-symbolic \
        -h int:value:"$percent" \
        -r 1001 \
        -u low "Brightness" "''${percent}%"
    '';
  };
in
{
  # Panggil skripnya di home.packages
  home.packages = [
    brightness-script
  ];
}
