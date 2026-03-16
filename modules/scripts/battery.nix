{ pkgs, ... }:

let
  batteryScript = pkgs.writeScript "battery-notify.sh" ''
    #!${pkgs.bash}/bin/bash
    export PATH=${pkgs.coreutils}/bin:${pkgs.dunst}/bin:${pkgs.libcanberra-gtk3}/bin:${pkgs.gtk3}/bin:/run/wrappers/bin:$PATH

    BAT="/sys/class/power_supply/BAT0"
    CAPACITY=$(cat "$BAT/capacity")
    STATUS=$(cat "$BAT/status")

    ICON_LOW="$HOME/.config/bspwm/src/assets/LowBat.png"
    ICON_FULL="$HOME/.config/bspwm/src/assets/FullBat.png"
    SOUND_LOW="$HOME/.config/dunst/sound/emotional-damage-meme.wav"
    SOUND_FULL="$HOME/.config/dunst/sound/hidup-jokowi.wav"

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
in
{
  home.file.".local/bin/battery-notify.sh".source = batteryScript;

  systemd.user.services.battery-check = {
    Unit.Description = "Battery check notifier";
    Service = {
      ExecStart = "${batteryScript}";
      Environment = [
      	"XDG_RUNTIME_DIR=%t"
      	"PATH=${pkgs.coreutils}/bin:${pkgs.dunst}/bin:${pkgs.libcanberra-gtk3}/bin:${pkgs.gtk3}/bin:/run/wrappers/bin:${pkgs.bash}/bin"
      	];
    };
  };

  systemd.user.timers.battery-check = {
    Unit.Description = "Run battery notifier every 1 minute";
    Timer = {
      OnBootSec = "30s";
      OnUnitActiveSec = "1m";
      Unit = "battery-check.service";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
