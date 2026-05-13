#!/usr/bin/env bash

DIR="$HOME/.config/$XDG_CURRENT_DESKTOP"
read -r RICE < "$DIR/.rice"
CONFIG="$DIR/rices/$RICE"
WID=$(awk '/^\(defwindow/ {print $2}' "$CONFIG/eww.yuck" 2> /dev/null || WID="bar")

if [[ -d "$CONFIG/scripts" ]]; then
  find "$CONFIG/scripts" -type f -exec chmod +x {} +
fi

eww -c "$CONFIG" daemon
sleep 0.3

for b in $WID; do
  eww -c "$CONFIG" open-many "$b" --toggle
done
