{
  home.file.".local/bin/xyz" = {
    text = ''
	    #!/usr/bin/env bash

		# ambil resolusi layar utama (X11 dengan xrandr)
		RES=$(xrandr | grep '*' | awk '{print $1}' | head -n1)
		SCREEN_W=''${RES%x*}
		SCREEN_H=''${RES#*x}

		read -p "lebar? " WIN_W
		read -p "tinggi? " WIN_H

		# hitung koordinat kiri-atas agar window tepat di tengah
		X=$(( (SCREEN_W - WIN_W) / 2 ))
		Y=$(( (SCREEN_H - WIN_H) / 2 ))

		echo "rectangle=''${WIN_W}x''${WIN_H}+''${X}+''${Y}"
    '';
    executable = true;
  };
}
