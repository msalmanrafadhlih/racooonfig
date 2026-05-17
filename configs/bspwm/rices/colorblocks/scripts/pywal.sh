#!/usr/bin/env bash

# Color files
DIR="$HOME/.config/$XDG_CURRENT_DESKTOP"
read -r RICE < "$DIR/.rice"

PFILE="/tmp/polybar_${UID}.ini"
RFILE="$DIR/rices/$RICE/scripts/rofi/colors.rasi"
WFILE="$HOME/.cache/wal/colors.sh"

# Get colors
pywal_get() {
wal -i "$1" \
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
	sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
	sed -i -e "s/foreground-alt = #.*/foreground-alt = $FGA/g" $PFILE
	sed -i -e "s/shade1 = #.*/shade1 = $SH1/g" $PFILE
	sed -i -e "s/shade2 = #.*/shade2 = $SH2/g" $PFILE
	sed -i -e "s/shade3 = #.*/shade3 = $SH3/g" $PFILE
	sed -i -e "s/shade4 = #.*/shade4 = $SH4/g" $PFILE
	sed -i -e "s/shade5 = #.*/shade5 = $SH5/g" $PFILE
	sed -i -e "s/shade6 = #.*/shade6 = $SH6/g" $PFILE
	sed -i -e "s/shade7 = #.*/shade7 = $SH7/g" $PFILE
	sed -i -e "s/shade8 = #.*/shade8 = $SH8/g" $PFILE
	
	# rofi
	cat > $RFILE <<- EOF
	/* colors */

	* {
	  al:    #00000000;
	  bg:    ${BG}FF;
	  bg1:   ${SH8}FF;
	  bg2:   ${SH7}FF;
	  bg3:   ${SH6}FF;
	  fg:    ${FGA}FF;
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

		BG=`printf "%s\n" "$background"`
		FG=`printf "%s\n" "$color0"`
		FGA=`printf "%s\n" "$color1"`
		SH1=`printf "%s\n" "$color2"`
		SH2=`printf "%s\n" "$color3"`
		SH3=`printf "%s\n" "$color4"`
		SH4=`printf "%s\n" "$color5"`
		SH5=`printf "%s\n" "$color6"`
		SH6=`printf "%s\n" "$color7"`
		SH7=`printf "%s\n" "$color8"`
		SH8=`printf "%s\n" "$color9"`

		change_color
	else
		echo -e "[!] Please enter the path to wallpaper. \n"
		echo "Usage : ./pywal.sh path/to/image"
	fi
else
	echo "[!] 'pywal' is not installed."
fi
