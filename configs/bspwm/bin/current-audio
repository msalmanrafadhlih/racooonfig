#!/usr/bin/env bash

# Cek lewat pactl (kalau ada)
if command -v pactl &>/dev/null; then
    server=$(pactl info | grep "Server Name" | cut -d: -f2- | xargs)

    if [[ "$server" == *"PipeWire"* ]]; then
        echo " PipeWire"
    elif [[ "$server" == *"PulseAudio"* ]]; then
        echo " PulseAudio"
    else
        echo " $server"
    fi

# Fallback ke ALSA
elif command -v aplay &>/dev/null; then
    echo "🎶 ALSA"
else
    echo "No sound"
fi
