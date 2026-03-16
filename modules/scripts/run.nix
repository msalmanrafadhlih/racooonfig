
{
  home.file.".local/bin/sh-runner.sh" = {
  	text = ''
#!/usr/bin/env bash

# Cari semua .sh di ~/.local/bin dan ~/.config
SCRIPTS=''$(find "$HOME/.local/bin" "$HOME/.config" -maxdepth 1 -type f -name "*.sh" 2>/dev/null)

# Kalau rofi minta mode "list", print daftar
if [ -z "$@" ]; then
    for f in $SCRIPTS; do
        basename "$f"
    done
else
    # Kalau user pilih entry, jalankan scriptnya
    FILE=''$(find "$HOME/.local/bin" "$HOME/.config" -maxdepth 1 -type f -name "$1" -print -quit)
    [ -n "$FILE" ] && exec "$FILE"
fi
	'';
	executable = true;
  };
}
