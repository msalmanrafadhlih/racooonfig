{ pkgs, ... }: {
    home.packages = [
        (pkgs.writeShellApplication {
          name = "set-gtk-theme";
          runtimeInputs = with pkgs; [ 
            glib         # untuk gsettings
            gnused       # untuk sed
            util-linux   # untuk column
            xsetroot # untuk xsetroot
            findutils    # untuk pencarian folder lebih akurat
            coreutils    # untuk ls, echo, dll
          ];

          text = ''
            # Fungsi pembantu untuk mencari folder di XDG_DATA_DIRS
            _list_assets() {
                local type=$1
                # NixOS butuh cara bersih memecah XDG_DATA_DIRS
                IFS=':' read -ra ADDR <<< "$XDG_DATA_DIRS"

                # Tambahkan folder lokal manual
                local search_paths=("''${ADDR[@]}")

                for p in "''${search_paths[@]}"; do
                    if [[ -d "$p/$type" ]]; then
                        find "$p/$type" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' 2>/dev/null
                    fi
                done | sort -u | grep -vE "^(default|hicolor|locolor|gnome|Graphics|flatpak)$" | column
            }

            # Gunakan exit bukan return karena ini file bin mandiri, bukan function shell
            if [[ "''${1:-}" == "-h" || "''${1:-}" == "--help" ]]; then
                echo "Usage: set-gtk-icons [SCHEME] [ICON] [CURSOR]"
                echo "Flags:"
                echo "  --list   : Menampilkan semua tema, ikon, dan kursor yang tersedia"
                echo "  --help   : Menampilkan bantuan ini"
                exit 0
            fi

            if [[ "''${1:-}" == "--list" ]]; then
                printf "\n--- [ AVAILABLE THEMES (SCHEME) ] ---\n"
                _list_assets "themes"
                printf "\n--- [ AVAILABLE ICONS & CURSORS ] ---\n"
                _list_assets "icons"
                exit 0
            fi

            scheme="''${1:-dynamic}"
            icon="''${2:-Vimix-white}"
            cursor="''${3:-Kafka}"

            echo "──────────────────────────────────────────────────"
            echo "🎨 Mengatur Tema GTK"
            echo "──────────────────────────────────────────────────"
            echo "• Scheme  : $scheme"
            echo "• Icon    : $icon"
            echo "• Cursor  : $cursor"
            echo "──────────────────────────────────────────────────"

            files=("$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini")
            for file in "''${files[@]}"; do
                if [[ -f "$file" ]]; then
                    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$scheme/" "$file"
                    sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$icon/" "$file"
                    sed -i "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$cursor/" "$file"
                fi
            done

            # Set the gtk theme untuk xsettingsd
            if [[ -f "$HOME/.config/xsettingsd/xsettingsd.conf" ]]; then
                sed -i "$HOME/.config/xsettingsd/xsettingsd.conf" \
                    -e "s|Net/ThemeName .*|Net/ThemeName \"$scheme\"|" \
                    -e "s|Net/IconThemeName .*|Net/IconThemeName \"$icon\"|" \
                    -e "s|Gtk/CursorThemeName .*|Gtk/CursorThemeName \"$cursor\"|"
            fi

            # Update index.theme (langsung overwrite lebih aman dan bersih)
            mkdir -p "$HOME/.icons/default"
            echo -e "[Icon Theme]\nName=Default\nComment=Default Cursor Theme\nInherits=$cursor" > "$HOME/.icons/default/index.theme"

            # Reload daemon and apply gtk theme
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
