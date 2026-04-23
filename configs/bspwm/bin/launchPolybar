#!/usr/bin/env bash
CONFIG_DIR="$HOME/.config/polybar/modules"
MAIN_CONFIG="$HOME/.config/polybar/config.ini"

# Tutup polybar lama dulu
pkill polybar

# Tunggu sampai benar-benar mati
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

chmod +x ~/.config/polybar/script/*.sh
# Gabung semua file jadi satu config sementara
cat "$MAIN_CONFIG" $CONFIG_DIR/* > /tmp/polybar_full_config.ini

# Jalankan semua bar (top + bottom)
for bar in top bottom; do
    polybar -c /tmp/polybar_full_config.ini "$bar" &
done

