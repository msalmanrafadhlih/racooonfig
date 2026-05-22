{ config, lib, ... }:
{
  config = lib.mkIf config.racooonfig.homeManager {
    home.file.".local/bin/wsize" = {
      text = ''
        #!/usr/bin/env bash

        # Fungsi untuk mengambil info dari window ID tertentu
        get_info() {
            local wid=$1
            # Mengambil geometry lewat xdotool (lebih readable)
            # Atau bisa gunakan bspc query jika ingin data internal bspwm
            xdotool getwindowgeometry "$wid"
        }

        if [[ "$1" == "-s" || "$1" == "--select" ]]; then
            echo "Klik pada window yang ingin dicek..."
            # Menunggu klik mouse dan mengambil Window ID
            WID=$(xdotool selectwindow)
            
            echo -e "\n--- Detail Window ---"
            get_info "$WID"
            # Selesai dan keluar (stdout sudah tercetak)
        else
            # Default: Berjalan seperti perintah watch yang Anda berikan
            watch -n 0.1 "xdotool getwindowgeometry \$(bspc query -N -n)"
        fi

        	'';
      executable = true;
    };
  };
}
