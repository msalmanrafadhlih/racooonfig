#!/usr/bin/env bash

read -r RICE < "$HOME/.config/$XDG_CURRENT_DESKTOP/.rice"
DIR="$HOME/.config/$XDG_CURRENT_DESKTOP/rices/$RICE"

change_panel() {
	# replace config with selected panel
	sed -i "s/^mode=.*/mode=$panel/" "$DIR/.var"
	sed -i "s/^top=.*/top=$top/" "$DIR/.var"
	sed -i "s/^bottom=.*/bottom=$btm/" "$DIR/.var"

	# Change wallpaper
	feh --bg-fill "$DIR"/wallpapers/"$bg"

	# Restarting polybar
	"$DIR/launch.sh" &
}

if  [[ "$1" = "--budgie" ]]; then
	panel="budgie"
	bg="budgie.jpg"
	top=35
	btm=0
	change_panel

elif  [[ "$1" = "--deepin" ]]; then
	panel="deepin"
	bg="deepin.jpg"
	top=0
	btm=50
	change_panel

elif  [[ "$1" = "--elight" ]]; then
	panel="elementary"
	bg="elementary.jpg"
	top=30
	btm=0
	change_panel

elif  [[ "$1" = "--edark" ]]; then
	panel="elementary_dark"
	bg="elementary_2.jpg"
	top=30
	btm=0
	change_panel

elif  [[ "$1" = "--gnome" ]]; then
	panel="gnome"
	bg="gnome.jpg"
	top=30
	btm=0
	change_panel

elif  [[ "$1" = "--klight" ]]; then
	panel="kde"
	bg="kde.jpg"
	top=0
	btm=35
	change_panel

elif  [[ "$1" = "--kdark" ]]; then
	panel="kde_dark"
	bg="kde_2.jpg"
	top=0
	btm=35
	change_panel

elif  [[ "$1" = "--liri" ]]; then
	panel="liri"
	bg="liri.png"
	top=0
	btm=45
	change_panel

elif  [[ "$1" = "--mint" ]]; then
	panel="mint"
	bg="mint.jpg"
	top=0
	btm=35
	change_panel

elif  [[ "$1" = "--ugnome" ]]; then
	panel="ubuntu_gnome"
	bg="ubuntu.jpg"
	top=30
	btm=0
	change_panel

elif  [[ "$1" = "--unity" ]]; then
	panel="ubuntu_unity"
	bg="ubuntu.jpg"
	top=30
	btm=0
	change_panel

elif  [[ "$1" = "--xubuntu" ]]; then
	panel="xubuntu"
	bg="xubuntu.png"
	top=30
	btm=0
	change_panel

elif  [[ "$1" = "--zorin" ]]; then
	panel="zorin"
	bg="zorin.png"
	top=0
	btm=45
	change_panel

else
	cat <<- _EOF_
	No option specified, Available options:
	--budgie   --deepin   --elight   --edark   --gnome   --klight
	--kdark   --liri   --mint   --ugnome   --unity   --xubuntu
	--zorin
	_EOF_
fi
