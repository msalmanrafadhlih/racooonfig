
{
  home.file.".local/bin/media.sh" = {
    text = ''
	#!/bin/sh

	case "$1" in
	  --next) playerctl next ;;
	  --previous) playerctl previous ;;
	  --toggle) playerctl play-pause ;;
	  --stop) playerctl stop ;;
	esac

	status=$(playerctl status 2>/dev/null)
	track=$(playerctl metadata title 2>/dev/null)
	artist=$(playerctl metadata artist 2>/dev/null)

	if [ -n "$track" ]; then
	  dunstify -i media-playback-start-symbolic -r 1003 -u low \
	    "Now Playing" "$artist - $track ($status)"
	else
	  dunstify -i media-playback-stop-symbolic -r 1003 -u low \
	    "Media" "$status"
	fi
    '';
    executable = true;
  };
}
