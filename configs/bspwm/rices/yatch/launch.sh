#!/usr/bin/env bash

set -euo pipefail

DIR="$HOME/.config/$XDG_CURRENT_DESKTOP"
TMP_CONFIG="/tmp/polybar_${UID}.ini"
# SHARED="$HOME/.config/polybar/shared"

read -r RICE < "$DIR/.rice"
MODULES="$DIR/rices/$RICE/modules"
VAR_FILE="$DIR/rices/$RICE/.var"
source "$VAR_FILE"


find "$DIR/rices/$RICE/scripts" -type f -exec chmod +x {} + 2>/dev/null || true

# Deteksi Hardware
adp=$(find /sys/class/power_supply -maxdepth 1 -type l -name "A*" -exec basename {} \; | head -n1 || echo "AC")
bat=$(find /sys/class/power_supply -maxdepth 1 -type l -name "BAT*" -exec basename {} \; | head -n1 || echo "BAT0")
card=$(find /sys/class/backlight -maxdepth 1 -type l -exec basename {} \; | head -n1 || echo "")
net=$(ip -o -4 route show to default | awk '{print $5}' | head -n1 || echo "eth0")
temp=$(for i in /sys/class/hwmon/hwmon*/temp*_input; do
    if [ "$(<$(dirname "$i")/name)" = "coretemp" ] && [ "$(<${i%_*}_label)" = "Package id 0" ]; then
        echo "$i"
        exit 0
    fi
done || echo "")

change_bar() {
    MAIN_CONFIG="$DIR/rices/$RICE/config.ini"

    if [[ ! -f "$MAIN_CONFIG" ]]; then
        dunstify -r 999 -t 5000 -i "$DIR/rices/$RICE/Icons/polybar.png" -u low \
            "Error" "Config $RICE.ini Not Found!"
        exit 1
    fi

    if [ "$XDG_CURRENT_DESKTOP" == "bspwm" ]; then
        bspc config top_padding "${top:-0}"
        bspc config bottom_padding "${bottom:-0}"
    fi

    # Gabungkan config
    # cat "$SHARED"/* \
    cat "$MODULES"/* \
        "$MAIN_CONFIG" > "$TMP_CONFIG" 2>/dev/null || true

    # Ambil nama bar
    bars=$(grep '^\[bar/' "$MAIN_CONFIG" | sed 's/^\[bar\///; s/\]$//' | tr '\n' ' ' || true)

    # Notification
dunstify \
  -t 5000 \
  -i "$HOME/.config/Assets/Icons/Neovim.png" \
  -u low \
  "Polybar Started" \
  "Bars: $bars
Style: ${mode:-unknown}

Top Padding: ${top:-0}
Bottom Padding: ${bottom:-0}"

    # Jalankan polybar
    while read -r mon; do
        for w in $bars; do
            MONITOR="$mon" \
            ADAPTER="$adp" \
            BATTERY="$bat" \
            BACKLIGHT="$card" \
            TEMPERATURE="$temp" \
            NETWORK="$net" \
            polybar -q "$w" -c "$TMP_CONFIG" &
        done
    done < <(polybar --list-monitors | cut -d: -f1)
}

change_bar &
