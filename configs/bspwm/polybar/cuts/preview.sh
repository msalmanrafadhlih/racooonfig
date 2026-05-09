#!/usr/bin/env bash

set -euo pipefail

DIR="$HOME/.config/polybar"

VAR_FILE="$DIR/cuts/.var"
TMP_CONFIG="/tmp/polybar_${UID}.ini"

SHARED="$DIR/shared"
MODULES="$DIR/cuts/modules"
MAIN_CONFIG="$DIR/cuts/preview.ini"

# Load variables
# Example:
# top=0
# bottom=50
# mode=cuts
source "$VAR_FILE"

# Apply bspwm padding
bspc config top_padding "${top:-0}"
bspc config bottom_padding "${bottom:-0}"

# Make all scripts executable
find "$DIR/cuts/scripts" -type f -exec chmod +x {} +

# Generate merged polybar config
cat \
  "$SHARED"/* \
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
  -r 999 \
  -t 5000 \
  -i "$DIR/cuts/Icons/polybar.png" \
  -u low \
  "Polybar Started" \
  "Bars: $bars
Style: ${mode:-unknown}

Top Padding: ${top:-0}
Bottom Padding: ${bottom:-0}"

# Launch polybar
LaunchPolybar &
