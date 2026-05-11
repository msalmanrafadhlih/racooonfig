#!/usr/bin/env bash
read -r RICE < "$HOME/.config/$XDG_CURRENT_DESKTOP/.rice"
SDIR="$HOME/.config/$XDG_CURRENT_DESKTOP/rices/$RICE/scripts"

FILE="$SDIR/rofi/launcher.rasi"

## random accent color
#COLORS=('#EC7875' '#EC6798' '#BE78D1' '#75A4CD' '#00C7DF' '#00B19F' '#61C766' \
#		'#B9C244' '#EBD369' '#EDB83F' '#E57C46' '#AC8476' '#6C77BB' '#6D8895')
#AC="${COLORS[$(( $RANDOM % 14 ))]}"
#SE="${COLORS[$(( $RANDOM % 14 ))]}"
#sed -i -e "s/ac: .*/ac:   ${AC}FF;/g" $FILE
#sed -i -e "s/se: .*/se:   ${SE}FF;/g" $FILE

rofi -no-config -no-lazy-grab -show drun -modi drun -theme "$FILE"
