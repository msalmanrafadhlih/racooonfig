{
  home.file.".local/bin/show-polybar.sh" = {
	  text = ''
#!/usr/bin/env bash
bspc config top_padding 27
bspc config bottom_padding 24

polybar-msg cmd show
	  '';
  executable = true;
  };
}
