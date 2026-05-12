#!/usr/bin/env bash

set -euo pipefail

DIR="$HOME/.config/$XDG_CURRENT_DESKTOP"
read -r RICE < "$DIR/.rice"

VAR_FILE="$DIR/rices/$RICE/.var"
TMP_CONFIG="/tmp/polybar_${UID}.ini"

SHARED="$HOME/.config/polybar/shared"

# Load variables
# Example:
# top=0
# bottom=50
# mode=blocks
source "$VAR_FILE"

MAIN_CONFIG="$DIR"/rices//$RICE/modules/"$mode".ini
# Apply bspwm padding
bspc config top_padding "${top:-0}"
bspc config bottom_padding "${bottom:-0}"

# Make all scripts executable
find "$DIR/rices/panels/scripts" -type f -exec chmod +x {} +

# Generate merged polybar config
cat \
  "$SHARED"/* \
  "$MAIN_CONFIG" \
  > "$TMP_CONFIG"

# Get all bar names
bars=$(
  grep -v '^;' "$MAIN_CONFIG" \
    | grep '^\[bar/' \
    | sed 's/^\[bar\///; s/\]$//'
)

# Notification
dunstify \
  -r 999 \
  -t 5000 \
  -i "$DIR/rices/$RICE/Icons/polybar.png" \
  -u low \
  "Polybar Started" \
  "Bars: $bars
Style: ${mode:-unknown}

Top Padding: ${top:-0}
Bottom Padding: ${bottom:-0}"

# Launch polybar
LaunchPolybar &
