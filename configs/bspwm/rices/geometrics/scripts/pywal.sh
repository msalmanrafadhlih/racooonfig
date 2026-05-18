#!/usr/bin/env bash

read -r RICE < "$HOME/.config/$XDG_CURRENT_DESKTOP/.rice"
SDIR="$HOME/.config/$XDG_CURRENT_DESKTOP/rices/$RICE/scripts"

# Color files
PFILE="/tmp/polybar_${UID}.ini"
RFILE="$SDIR/rofi/colors.rasi"
WFILE="$HOME/.cache/wal/colors.sh"

# Get colors
pywal_get() {
feh --bg-fill "$1"
wal -i "$1" -n \
        -q -e \
        --vte \
        -a 70 \
        --contrast 4.5 \
        --backend haishoku &

}

# Change colors
change_color() {
	# polybar
	sed -i -e "s/background = #.*/background = $BG/g" $PFILE
	sed -i -e "s/background-alt = #.*/background-alt = $BGA/g" $PFILE
	sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
	sed -i -e "s/foreground-alt = #.*/foreground-alt = $FG/g" $PFILE
	sed -i -e "s/primary = #.*/primary = $AC/g" $PFILE
	sed -i -e 's/red = #.*/red = #B71C1C/g' $PFILE
	sed -i -e 's/yellow = #.*/yellow = #F57F17/g' $PFILE
	
	# rofi
	cat > $RFILE <<- EOF
	/* colors */

	* {
	  al:   #00000000;
	  bg:   ${BG}FF;
	  bga:  ${BGA}FF;
	  fg:   ${FG}FF;
	  ac:   ${AC}FF;
	}
	EOF

	polybar-msg cmd restart
}

# Main
if [[ -x "$(which wal)" ]]; then
	if [[ "$1" ]]; then
		pywal_get "$1"
		sleep 0.5

		# Source the pywal color file
		if [[ -e "$WFILE" ]]; then
			. "$WFILE"
		else
			echo 'Color file does not exist, exiting...'
			exit 1
		fi

		BG=`printf "%s\n" "#FFFFFF"`
		FG=`printf "%s\n" "$background"`
		BGA=`printf "%s\n" "$color7"`
		FGA=`printf "%s\n" "$color3"`
		AC=`printf "%s\n" "$color1"`

		change_color
	else
		echo -e "[!] Please enter the path to wallpaper. \n"
		echo "Usage : ./pywal.sh path/to/image"
	fi
else
	echo "[!] 'pywal' is not installed."
fi
