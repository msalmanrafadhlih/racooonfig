{ program, pkgs, lib, ... }:

{
  home.file.".local/bin/opencam" = {
  	text = ''
  		#!/usr/bin/env bash
		# Open webcam floating window di BSPWM
		# Usage: opencam.sh <posisi> <ukuran_persen> <device_kamera>
		# posisi: kanan-bawah, kanan-atas, kiri-bawah, kiri-atas, tengah
		# ukuran_persen: lebar kamera dalam % layar (default: 10)
		# device_kamera: video0, video1, dll (default: video0)

		POS=''${1:-kanan-bawah}
		SIZE_PERCENT=''${2:-10}
		CAM_DEVICE=''${3:-video0}

		# Cek kamera tersedia
		if [ ! -e "/dev/''${CAM_DEVICE}" ]; then
		    echo "❌ Kamera /dev/''${CAM_DEVICE} tidak ditemukan!"
		    echo "🔍 Kamera yang tersedia:"
		    for cam in /dev/video*; do
		        if [ -e "$cam" ]; then
		            name=$(v4l2-ctl --device="$cam" --all 2>/dev/null | grep "Card type" | sed 's/.*: //')
		            echo " - ''$(basename $cam) (''${name:-Unknown})"
		        fi
		    done
		    exit 1
		fi

		# Ambil resolusi layar
		SCREEN_RES=''$(xrandr | grep '*' | awk '{print $1}')
		SCREEN_W=''$(echo $SCREEN_RES | cut -d'x' -f1)
		SCREEN_H=''$(echo $SCREEN_RES | cut -d'x' -f2)

		# Ambil ukuran fisik layar dalam mm
		SCREEN_W_MM=''$(xrandr | grep " connected" | sed -n 's/.* \([0-9]\+\)mm x \([0-9]\+\)mm.*/\1/p')
		SCREEN_H_MM=''$(xrandr | grep " connected" | sed -n 's/.* \([0-9]\+\)mm x \([0-9]\+\)mm.*/\2/p')

		# Hitung DPI
		DPI_X=''$(echo "$SCREEN_W $SCREEN_W_MM" | awk '{printf "%.0f", $1 / ($2 / 25.4)}')
		DPI_Y=''$(echo "$SCREEN_H $SCREEN_H_MM" | awk '{printf "%.0f", $1 / ($2 / 25.4)}')

		# Pixel per cm
		PX_PER_CM_X=''$(echo "$DPI_X" | awk '{printf "%.0f", $1 / 2.54}')
		PX_PER_CM_Y=''$(echo "$DPI_Y" | awk '{printf "%.0f", $1 / 2.54}')

		# Ukuran kamera
		CAM_W=''$((SCREEN_W * SIZE_PERCENT / 100))
		CAM_H=''$((CAM_W * 3 / 4)) # rasio 4:3

		# Offset 1 cm dikurangi 10%
		OFFSET_X=''$((PX_PER_CM_X - PX_PER_CM_X / 10))
		OFFSET_Y=''$((PX_PER_CM_Y - PX_PER_CM_Y / 10))

		# Jalankan ffplay
		ffplay -noborder -video_size ''${CAM_W}x''${CAM_H} \
		    -fflags nobuffer -f v4l2 -i /dev/''${CAM_DEVICE} &
		FFPLAY_PID=$!

		# Tunggu window muncul
		sleep 2

		# Cari ID window
		WIN_ID=''$(xdotool search --pid $FFPLAY_PID | head -n 1)

		# Set floating & pindahkan
		if command -v bspc &>/dev/null && [ -n "$WIN_ID" ]; then
		    bspc node $WIN_ID -t floating

		    # Default posisi (kanan-bawah)
		    POS_X=''$((SCREEN_W - CAM_W - OFFSET_X))
		    POS_Y=''$((SCREEN_H - CAM_H - OFFSET_Y))

		    case "$POS" in
		        kiri-atas)
		            POS_X=$OFFSET_X
		            POS_Y=$OFFSET_Y
		            ;;
		        kiri-bawah)
		            POS_X=$OFFSET_X
		            POS_Y=''$((SCREEN_H - CAM_H - OFFSET_Y))
		            ;;
		        kanan-atas)
		            POS_X=''$((SCREEN_W - CAM_W - OFFSET_X))
		            POS_Y=$OFFSET_Y
		            ;;
		        tengah)
		            POS_X=''$(( (SCREEN_W - CAM_W) / 2 ))
		            POS_Y=''$(( (SCREEN_H - CAM_H) / 2 ))
		            ;;
		    esac

		    # Anti overflow
		    [ $POS_X -lt 0 ] && POS_X=0
		    [ $POS_Y -lt 0 ] && POS_Y=0
		    [ $POS_X -gt ''$((SCREEN_W - CAM_W)) ] && POS_X=''$((SCREEN_W - CAM_W))
		    [ $POS_Y -gt ''$((SCREEN_H - CAM_H)) ] && POS_Y=''$((SCREEN_H - CAM_H))

		    xdotool windowmove $WIN_ID $POS_X $POS_Y
		fi

		# Tunggu sampai ffplay ditutup
		wait $FFPLAY_PID
  	'';
  	executable = true;
  };
}
