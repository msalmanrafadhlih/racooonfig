#!/usr/bin/env bash

set -euo pipefail

DIR="$HOME/.config/bspwm"
read -r RICE < "$DIR/.rice"

VAR_FILE="$DIR/rices/$RICE/.var"
TMP_CONFIG="/tmp/polybar_${UID}.ini"

MODULES="$DIR/rices/$RICE/modules"
MAIN_CONFIG="$DIR/rices/$RICE/config.ini"

# Load variables
# Example:
# top=0
# bottom=50
# mode=$RICE
#
source "$VAR_FILE"

# Apply bspwm padding
bspc config top_padding "${top:-0}"
bspc config bottom_padding "${bottom:-0}"

# Make all scripts executable
find "$DIR/rices/$RICE/scripts" -type f -exec chmod +x {} +

# Generate merged polybar config
cat \
  "$MAIN_CONFIG" \
  "$MODULES"/* \
  > "$TMP_CONFIG"

# Get all bar names
bars=$(
  grep -v '^;' "$MAIN_CONFIG" \
    | grep '^\[bar/' \
    | sed 's/^\[bar\///; s/\]$//'
)

# Notification
dunstify \
  -t 5000 \
  -i "$HOME/.config/Assets/Icons/Neovim.png" \
  -u low \
  "Polybar Started" \
  "Bars: $bars
Style: ${mode:-unknown}

Top Padding: ${top:-0}
Bottom Padding: ${bottom:-0}"

# Launch polybar
LaunchPolybar &
