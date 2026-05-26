#!/usr/bin/env bash

DIR="$HOME/.config/$XDG_CURRENT_DESKTOP"
read -r RICE < "$DIR/.rice"
path="$DIR/rices/$RICE"

"$path/scripts/settings_watcher.sh" >/dev/null 2>&1 &
"$path/scripts/volume_listener.sh" >/dev/null 2>&1 &

systemctl --user enable --now easyeffects
gsettings set org.gnome.desktop.interface cursor-size 24
quickshell -p "$path/scripts/quickshell/Shell.qml" >/dev/null 2>&1 &
python3 "$path/scripts/quickshell/focustime/focus_daemon.py" >/dev/null 2>&1 &
