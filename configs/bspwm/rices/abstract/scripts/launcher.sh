#!/usr/bin/env bash

read -r RICE < "$HOME/.config/$XDG_CURRENT_DESKTOP/.rice"
SDIR="$HOME/.config/$XDG_CURRENT_DESKTOP/rices/$RICE/scripts/rofi/launcher.rasi"

rofi -no-config -no-lazy-grab -show drun -modi drun -theme "$SDIR"
