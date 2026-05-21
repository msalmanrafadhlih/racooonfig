{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "set-gtk-theme";
      runtimeInputs = with pkgs; [
        glib
        gnused
        util-linux
        xsetroot
        findutils
        coreutils
      ];

      text = ''
    set -euo pipefail

    # ================================
    # Helpers
    # ================================

    _list_assets() {
        local type=$1
        IFS=':' read -ra search_paths <<< "''${XDG_DATA_DIRS:-/usr/share}"

        for p in "''${search_paths[@]}"; do
            if [[ -d "$p/$type" ]]; then
                find "$p/$type" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' 2>/dev/null
            fi
        done | sort -u | grep -vE "^(default|hicolor|locolor|gnome|Graphics|flatpak)$" | column
    }

    # Helper untuk set/update value pada file INI dengan aman
    _set_ini_key() {
        local file="$1"
        local key="$2"
        local value="$3"
        if grep -q "^''${key}=" "$file"; then
            sed -i "s|^''${key}=.*|''${key}=''${value}|" "$file"
        else
            echo "''${key}=''${value}" >> "$file"
        fi
    }

    _set_flatpak_override() {
        local scheme="$1"
        local override="$HOME/.local/share/flatpak/overrides/global"
        local new_fs="/home/$USER/.themes/$scheme:ro"

        mkdir -p "$(dirname "$override")"
        touch "$override"

        # Pastikan section ada
        grep -q "^\[Context\]" "$override" || printf "\n[Context]\n" >> "$override"
        grep -q "^\[Environment\]" "$override" || printf "\n[Environment]\n" >> "$override"

        # ---- filesystems ----
        if grep -q "^filesystems=" "$override"; then
            if ! grep -q "$new_fs" "$override"; then
                sed -i "s|^filesystems=.*|&;$new_fs|" "$override"
            fi
        else
            sed -i "/^\[Context\]/a filesystems=$new_fs" "$override"
        fi

        # ---- GTK_THEME ----
        if grep -q "^XCURSOR_THEME=" "$override"; then
            sed -i "s|^XCURSOR_THEME=.*|XCURSOR_THEME=$scheme|" "$override"
        else
            sed -i "/^\[Environment\]/a XCURSOR_THEME=$scheme" "$override"
        fi
    }

    _setup_cursor() {
        local cursor_name="$1"
        local cursor_pkg_path="$2"

        local theme_dirs=(
            "$HOME/.icons"
            "/usr/share/icons"
            "$HOME/.local/share/icons"
            "$HOME/.local/share/flatpak/exports/share/icons"
        )

        for dir in "''${theme_dirs[@]}"; do
            mkdir -p "$dir/default"
            ln -sfn "$cursor_pkg_path/share/icons/$cursor_name" "$dir"

            printf "[Icon Theme]\nInherits=%s\n" "$cursor_name" > "$dir/default/index.theme"
        done
    }

    # ================================
    # CLI Parse
    # ================================

    if [[ "''${1:-}" == "-h" || "''${1:-}" == "--help" ]]; then
        echo "Usage: set-gtk-theme [SCHEME] [ICON] [CURSOR]"
        echo "  --list   : List assets"
        echo "  --help   : Help"
        exit 0
    fi

    if [[ "''${1:-}" == "--list" ]]; then
        printf "\n--- [ THEMES ] ---\n"
        _list_assets "themes"
        printf "\n--- [ ICONS ] ---\n"
        _list_assets "icons"
        exit 0
    fi

    scheme="''${1:-dynamic}"
    icon="''${2:-Vimix-white}"
    cursor="''${3:-Kafka}"

    echo "────────────────────────────────────────"
    echo "🎨 GTK Theme Setup"
    echo "• Scheme : $scheme"
    echo "• Icon   : $icon"
    echo "• Cursor : $cursor"
    echo "────────────────────────────────────────"

    # ================================
    # GTK config
    # ================================

    gtk_files=(
      "$HOME/.config/gtk-3.0/settings.ini"
      "$HOME/.config/gtk-4.0/settings.ini"
    )

    for file in "''${gtk_files[@]}"; do
        mkdir -p "$(dirname "$file")"
        
        # Buat file beserta header jika belum eksis atau kosong
        if [[ ! -s "$file" ]]; then
            cat > "$file" <<EOF
[Settings]
gtk-font-name=Adwaita Sans 11
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF
        fi

        _set_ini_key "$file" "gtk-theme-name" "$scheme"
        _set_ini_key "$file" "gtk-icon-theme-name" "$icon"
        _set_ini_key "$file" "gtk-cursor-theme-name" "$cursor"
    done

    # ================================
    # xsettingsd
    # ================================
    
    xset_conf="$HOME/.config/xsettingsd/xsettingsd.conf"
    if [[ -f "$xset_conf" ]]; then
        sed -i -e "s|Net/ThemeName .*|Net/ThemeName \"$scheme\"|" \
               -e "s|Net/IconThemeName .*|Net/IconThemeName \"$icon\"|" \
               -e "s|Gtk/CursorThemeName .*|Gtk/CursorThemeName \"$cursor\"|" \
               "$xset_conf"
    fi

    # ================================
    # Cursor  
    # ================================

    _setup_cursor "$cursor" "${pkgs.cursor-memes}"
    _set_flatpak_override "$cursor"
    export XCURSOR_THEME=$cursor

    # ================================
    # Apply Changes
    # ================================

    if pidof -q xsettingsd; then
        pkill -HUP xsettingsd
    fi

    xsetroot -cursor_name left_ptr

    echo "✅ Berhasil diterapkan!"
      '';
    })
  ];
}
