#!/usr/bin/env bash

SDIR="$HOME/.config/$XDG_CURRENT_DESKTOP/rices/cuts/scripts"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $SDIR/rofi/styles.rasi \
<<< " Black| Adapta| Dark| Red| Green| Teal| Gruvbox| Nord| Solarized| Cherry|")"
            case "$MENU" in
				*Black) "$SDIR"/styles.sh --mode1 ;;
				*Adapta) "$SDIR"/styles.sh --mode2 ;;
				*Dark) "$SDIR"/styles.sh --mode3 ;;
				*Red) "$SDIR"/styles.sh --mode4 ;;
				*Green) "$SDIR"/styles.sh --mode5 ;;
				*Teal) "$SDIR"/styles.sh --mode6 ;;
				*Gruvbox) "$SDIR"/styles.sh --mode7 ;;
				*Nord) "$SDIR"/styles.sh --mode8 ;;
				*Solarized) "$SDIR"/styles.sh --mode9 ;;
				*Cherry) "$SDIR"/styles.sh --mode10 ;;
            esac
