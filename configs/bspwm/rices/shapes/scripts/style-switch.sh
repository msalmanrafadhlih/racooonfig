#!/usr/bin/env bash

read -r RICE < "$HOME/.config/$XDG_CURRENT_DESKTOP/.rice"
SDIR="$HOME/.config/$XDG_CURRENT_DESKTOP/rices/$RICE/modules"

FILE="$SDIR/glyphs.ini"

# Replace Glyphs
change_style() {
	sed -i -e "s/gleft = .*/gleft = $1/g" $FILE
	sed -i -e "s/gright = .*/gright = $2/g" $FILE

	polybar-msg cmd restart
}


# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $HOME/.config/polybar/shapes/scripts/rofi/styles.rasi \
<<< "♥ Style-1|♥ Style-2|♥ Style-3|♥ Style-4|♥ Style-5|♥ Style-6|♥ Style-7|♥ Style-8|♥ Style-9|♥ Style-10|♥ Style-11|♥ Style-12|")"
            case "$MENU" in
				## Light Colors
				*Style-1) change_style   ;;
				*Style-2) change_style   ;;
				*Style-3) change_style   ;;
				*Style-4) change_style   ;;
				*Style-5) change_style   ;;
				*Style-6) change_style   ;;
				*Style-7) change_style   ;;
				*Style-8) change_style   ;;
				*Style-9) change_style   ;;
				*Style-10) change_style   ;;
				*Style-11) change_style   ;;
				*Style-12) change_style   ;;
            esac
