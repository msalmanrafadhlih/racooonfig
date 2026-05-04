{ pkgs, ... }: {
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
        # ================================
        # Helpers
        # ================================

        _list_assets() {
            local type=$1
            IFS=':' read -ra ADDR <<< "$XDG_DATA_DIRS"
            local search_paths=("''${ADDR[@]}")

            for p in "''${search_paths[@]}"; do
                if [[ -d "$p/$type" ]]; then
                    find "$p/$type" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' 2>/dev/null
                fi
            done | sort -u | grep -vE "^(default|hicolor|locolor|gnome|Graphics|flatpak)$" | column
        }

        _set_flatpak_override() {
            local scheme="$1"
            local override="$HOME/.local/share/flatpak/overrides/global"

            mkdir -p "$(dirname "$override")"
            touch "$override"

            # Ensure sections exist
            grep -q "^\[Context\]" "$override" || printf "\n[Context]\n" >> "$override"
            grep -q "^\[Environment\]" "$override" || printf "\n[Environment]\n" >> "$override"

            local new_fs="/home/$USER/.themes/$scheme:ro"

            # ---- filesystems ----
            if grep -q "^filesystems=" "$override"; then
                if ! grep -q "$new_fs" "$override"; then
                    sed -i "s|^filesystems=.*|&;$new_fs|" "$override"
                fi
            else
                sed -i "/^\[Context\]/a filesystems=$new_fs" "$override"
            fi

            # ---- GTK_THEME ----
            if grep -q "^GTK_THEME=" "$override"; then
                sed -i "s|^GTK_THEME=.*|GTK_THEME=$scheme|" "$override"
            else
                sed -i "/^\[Environment\]/a GTK_THEME=$scheme" "$override"
            fi
        }

        # ================================
        # CLI
        # ================================

        if [[ "''${1:-}" == "-h" || "''${1:-}" == "--help" ]]; then
            echo "Usage: set-gtk-icons [SCHEME] [ICON] [CURSOR]"
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

        files=(
          "$HOME/.config/gtk-3.0/settings.ini"
          "$HOME/.config/gtk-4.0/settings.ini"
        )

        for file in "''${files[@]}"; do
            if [[ -f "$file" ]]; then
                sed -i "s/gtk-theme-name=.*/gtk-theme-name=$scheme/" "$file"
                sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$icon/" "$file"
                sed -i "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$cursor/" "$file"
            else
                mkdir -p "$(dirname "$file")"
                cat > "$file" <<EOF
[Settings]
gtk-theme-name=$scheme
gtk-icon-theme-name=$icon
gtk-font-name=Adwaita Sans 11
gtk-cursor-theme-name=$cursor
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF
            fi
        done

        # ================================
        # xsettingsd
        # ================================

        if [[ -f "$HOME/.config/xsettingsd/xsettingsd.conf" ]]; then
            sed -i "$HOME/.config/xsettingsd/xsettingsd.conf" \
                -e "s|Net/ThemeName .*|Net/ThemeName \"$scheme\"|" \
                -e "s|Net/IconThemeName .*|Net/IconThemeName \"$icon\"|" \
                -e "s|Gtk/CursorThemeName .*|Gtk/CursorThemeName \"$cursor\"|"
        fi

        # ================================
        # Cursor
        # ================================

        mkdir -p "$HOME/.icons"
        ln -sfn "${pkgs.cursor-memes}/share/icons/$cursor" "$HOME/.icons/$cursor"

        mkdir -p "$HOME/.icons/default"
        mkdir -p "$HOME/.local/share/icons/default"

        printf "[Icon Theme]\nInherits=%s\n" "$cursor" > "$HOME/.icons/default/index.theme"
        printf "[Icon Theme]\nInherits=%s\n" "$cursor" > "$HOME/.local/share/icons/default/index.theme"

        # ================================
        # Flatpak (pakai function)
        # ================================

        _set_flatpak_override "$scheme"

        # ================================
        # Apply
        # ================================

        if pidof -q xsettingsd; then
            pkill -HUP xsettingsd
        fi

        if command -v xsetroot >/dev/null 2>&1; then
            xsetroot -cursor_name left_ptr
        fi

        echo "✅ Berhasil diterapkan!"
      '';
    })
  ];
}
