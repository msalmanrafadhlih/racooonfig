#!/usr/bin/env bash

DIR="$HOME/.config/$XDG_CURRENT_DESKTOP"
read -r RICE < "$DIR/.rice"
SDIR="$DIR/rices/$RICE/scripts/rofi/launcher.rasi"

rofi -no-config -no-lazy-grab -show drun -modi drun -theme "$SDIR"
