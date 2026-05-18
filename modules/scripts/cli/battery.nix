{ pkgs, ... }:

let
  batteryScript = pkgs.writeShellApplication {
    name = "battery-notify";
    
    runtimeInputs = with pkgs; [ 
      coreutils 
      dunst 
      libcanberra-gtk3 
    ];

    text = ''
      BAT="/sys/class/power_supply/BAT0"
      CAPACITY=$(cat "$BAT/capacity")
      STATUS=$(cat "$BAT/status")

      ICON_LOW="$HOME/.config/Assets/Icons/LowBat.png"
      ICON_FULL="$HOME/.config/Assets/Icons/FullBat.png"
      SOUND_LOW="$HOME/.config/Assets/Sounds/spongebob.wav"
      SOUND_FULL="$HOME/.config/Assets/Sounds/hidup-jokowi.wav"

      if [[ "$STATUS" == "Discharging" && "$CAPACITY" -le 20 ]]; then
        dunstify -i "$ICON_LOW" \
          -h int:value:"$CAPACITY" \
          -r 2001 \
          -u critical "Battery Low" "$CAPACITY % remaining"
        canberra-gtk-play -f "$SOUND_LOW" -V 3.0
      elif [[ "$STATUS" == "Full" || ( "$STATUS" == "Charging" && "$CAPACITY" -ge 95 ) ]]; then
        dunstify -i "$ICON_FULL" \
          -h int:value:"$CAPACITY" \
          -r 2002 \
          -u normal "Battery Full" "$CAPACITY % charged. You can unplug the charger."
        canberra-gtk-play -f "$SOUND_FULL" -V 3.0
      fi
    '';
  };
in
{
  # Opsional: Tambahkan ke packages jika ingin mengeksekusinya secara manual via terminal
  environment.systemPackages = [ batteryScript ];

  systemd.user.services.battery-check = {
    description = "Battery check notifier";

    serviceConfig = {
      # Panggil path executable-nya secara langsung
      ExecStart = "${batteryScript}/bin/battery-notify";
      Environment = [ "XDG_RUNTIME_DIR=%t" ];
      Type = "oneshot";
    };
  };

  systemd.user.timers.battery-check = {
    description = "Run battery notifier every 1 minute";

    timerConfig = {
      OnBootSec = "30s";
      OnUnitActiveSec = "1m";
      Unit = "battery-check.service";
    };
    wantedBy = [ "timers.target" ];
  };
}
