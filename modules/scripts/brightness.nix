
{
  home.file.".local/bin/brightness.sh" = {
      text =''
	#!/bin/sh

	case "$1" in
	  up) brightnessctl set +5% ;;
	  down) brightnessctl set 5%- ;;
	esac

	current=$(brightnessctl get)
	max=$(brightnessctl max)
	percent=$(( current * 100 / max ))

	dunstify -t 2000 -i display-brightness-symbolic \
	  -h int:value:"$percent" \
	  -r 1001 \
	  -u low "Brightness" "''${percent}%"
      '';
      executable = true;
 };
}
