{
  home.file.".local/bin/hide-polybar.sh" = {
      text = ''
#!/bin/sh
bspc config top_padding 0
bspc config bottom_padding 0

polybar-msg cmd hide
      '';
  executable = true;
  };
}
