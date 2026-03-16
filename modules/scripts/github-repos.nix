{ repss, libs, manager, ... }:

{
  home.file.".local/bin/repository.sh" = {
	text = ''
#!/bin/sh
set -eu

terminal="kitty"

configs="''$(ls -1d "$HOME"/.repos/*/ 2>/dev/null | xargs -n1 basename || true)"
[ -n "$configs" ] || exit 0

if [ $# -eq 0 ]; then
    printf '%s\n' $configs
    exit 0
fi

chosen="$1"
[ -n "$chosen" ] || exit 0

dir="$HOME/.repos/$chosen"

# Nuke any existing st (optional, kalau emang mau clean start)
pkill $terminal 2>/dev/null || true
sleep 0.1

"$terminal" --class=YaziTerm -e tmux new-session -As "$chosen" -c "$dir" yazi >/dev/null 2>&1 & exit 0
	'';
	executable = true;
  };
}
