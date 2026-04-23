#!/usr/bin/env bash

# Daftar prioritas player
players=(spotify mpd)

for p in "${players[@]}"; do
    if playerctl -p "$p" status &>/dev/null; then
        player="$p"
        break
    fi
done

# Kalau tak ada player aktif
[[ -z "$player" ]] && echo "🎵" && exit

status=$(playerctl -p "$player" status 2>/dev/null)
meta=$(playerctl -p "$player" metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    icon=""
elif [[ "$status" == "Paused" ]]; then
    icon=""
else
    icon=""
fi

echo "$meta"
