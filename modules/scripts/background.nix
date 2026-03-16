
{
  home.file.".local/bin/bg-slideshow" = {
    text = ''
		#!/bin/sh
		BG=$HOME/Pictures/Wallpaper/wallpaper8.jpeg
		
        feh --bg-scale "$BG"
	'';
	executable = true;
  };
}
