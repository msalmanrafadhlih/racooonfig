#!/usr/bin/env bash

# File untuk nyimpan waktu terakhir ada window aktif
STATE_FILE="/tmp/polybar_xwindow_last_active"

# Ambil judul window aktif
TITLE=$(xdotool getwindowfocus getwindowname 2>/dev/null)

# Kalau ada window aktif → reset state
if [ -n "$TITLE" ]; then
    date +%s > "$STATE_FILE"
    echo "$TITLE"
    exit 0
fi

# Kalau gak ada window → hitung sudah berapa lama kosong
NOW=$(date +%s)
LAST=$(cat "$STATE_FILE" 2>/dev/null || echo $NOW)
DIFF=$((NOW - LAST))

# Timeline pesan
if   [ $DIFF -lt 60 ];   then MSG="Empty"
elif [ $DIFF -lt 120 ];  then MSG="Still Empty.."
elif [ $DIFF -lt 180 ];  then MSG="Boring.."
elif [ $DIFF -lt 240 ];  then MSG="Just Open Something bruh..!"
elif [ $DIFF -lt 360 ];  then MSG="Why open laptop without doing anything??"
elif [ $DIFF -lt 480 ];  then MSG="Are you sleeping??"
elif [ $DIFF -lt 600 ];  then MSG="Definitely sleep"
else MSG="Zzz..."
fi

echo "$MSG"
