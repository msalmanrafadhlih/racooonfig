#!/usr/bin/env bash

DIR="$HOME/.config/polybar"
read -r BAR < "$DIR/panels/.bar"
SHARED="$HOME/.config/polybar/shared"
MAIN_CONFIG="$DIR/panels/panel/$BAR.ini"

adp=$(ls /sys/class/power_supply | grep -iE 'ac|adp|adapter' | head -n1)
bat=$(ls /sys/class/power_supply | grep -i 'bat' | head -n1)
card=$(ls /sys/class/backlight | head -n1)
net=$(ip -o -4 route show to default | awk '{print $5}' | head -n1)

# Kill polybar lama
pkill polybar

while pgrep -u "$UID" -x polybar >/dev/null; do
  sleep 1
done

chmod +x "$DIR/panels/scripts/"*.sh
# Gabung semua file jadi satu config sementara
cat $SHARED/* "$MAIN_CONFIG"  > /tmp/polybar_full_config.ini

# Ambil semua bar dari config (kompatibel semua versi polybar)
bars=$(grep '^\[bar/' "$MAIN_CONFIG" | grep -v '^;' | sed 's/^\[bar\///; s/\]$//')

# Launch per monitor + per bar
while read -r mon; do
  for bar in $bars; do
    MONITOR="$mon" \
    ADAPTER="$adp" \
    BATTERY="$bat" \
    BACKLIGHT="$card" \
    NETWORK="$net" \
    polybar -q "$bar" -c /tmp/polybar_full_config.ini &
  done
done < <(polybar --list-monitors | cut -d: -f1)

dunstify -r 999 -t 5000 -i "$HOME/.config/Assets/Icons/Neovim.png" -u low \
  "Polybar Started" \
  "Bars: $bars
Style: $BAR

ADAPTER: $adp
BATTERY: $bat
BACKLIGHT: $card
NETWORK: $net"
