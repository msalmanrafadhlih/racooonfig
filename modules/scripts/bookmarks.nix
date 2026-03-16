{ libs, pkgs, service, ... }:

{
  home.file.".local/bin/bookmarks.sh" = {
    text = ''

#!/bin/sh
set -eu

# Files
PERS_FILE="''${PERS_FILE:-$HOME/.config/bookmarks/personal.txt}"
WORK_FILE="''${WORK_FILE:-$HOME/.config/bookmarks/work.txt}"

# Browser: gunakan $BROWSER kalau ada, fallback ke xdg-open
BROWSER_CMD="''${BROWSER:-}"
if [ -z "$BROWSER_CMD" ]; then
    BROWSER_CMD="$(command -v xdg-open || true)"
fi
FALLBACK="''${BROWSER_CMD:-echo}"

# Ensure files exist
mkdir -p "$(dirname "$PERS_FILE")"

if [ ! -f "$PERS_FILE" ]; then
    cat > "$PERS_FILE" << EOF
# personal
Tquilla :: https://github.com/msalmanrafadhlih/Nixos-Dotsfile
EOF
fi

if [ ! -f "$WORK_FILE" ]; then
    cat > "$WORK_FILE" << EOF
# work
MochSal :: https://msalmanrafadhlih.github.io/My-portofolio/
EOF
fi

emit() {
    tag="$1"
    file="$2"
    [ -f "$file" ] || return 0
    grep -vE '^\s*(#|$)' "$file" | while IFS= read -r line; do
        case "$line" in
            *"::"*)
                lhs="''${line%%::*}"
                rhs="''${line#*::}"
                lhs="$(printf '%s' "$lhs" | sed 's/[[:space:]]*$//')"
                rhs="$(printf '%s' "$rhs" | sed 's/^[[:space:]]*//')"
                printf '[%s] %s :: %s\n' "$tag" "$lhs" "$rhs"
                ;;
            *)
                printf '[%s] %s :: %s\n' "$tag" "$line" "$line"
                ;;
        esac
    done
}

# Kalau tidak ada argumen: keluarkan list ke Rofi
if [ $# -eq 0 ]; then
    {
        echo "          🔹 === BOOKMARKS === 🔹"

        emit personal "$PERS_FILE"
        emit work "$WORK_FILE"
    } | sort
    exit 0
fi

# Kalau ada argumen: itu adalah pilihan dari user
choice="$1"

case "$choice" in
    *"🔹 === BOOKMARKS === 🔹"*)
        # Catatan: Karena Rofi berjalan di background/GUI, jika $EDITOR Anda berbasis CLI
        # seperti Neovim, Anda harus membungkusnya dengan terminal emulator.
        # Contoh: kitty -e nvim ~/.config/bookmarks
        "$TERMINAL" -e "$EDITOR" ~/.config/bookmarks > /dev/null 2>&1 &
        exit 0
        ;;
esac

# Parse raw URL
raw="''${choice##* :: }"
raw="$(printf '%s' "$raw" |
    sed -e 's/[[:space:]]\+#.*$//' -e 's/[[:space:]]\/\/.*$//' \
        -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

case "$raw" in
    http://* | https://* | file://* | about:* | chrome:*) url="$raw" ;;
    *) url="https://$raw" ;;
esac

# Gunakan browser global
if [ -n "$BROWSER_CMD" ]; then
    kdocker -f -q nohup "$BROWSER_CMD" "$url" > /dev/null 2>&1 &
    exit 0
fi

# Fallback
kdocker -q -f nohup "$FALLBACK" "$url" > /dev/null 2>&1 &
    '';
    executable = true;
  };
}
