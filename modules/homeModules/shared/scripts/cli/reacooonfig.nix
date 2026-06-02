{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "SAVEFLAKE" ''
      # ─── fzf helper ────────────────────────────────────────────────────────────
      tmux_fzf() {
        local input="$1"
        local prompt="$2"
        local tmp
        tmp=$(mktemp)

        printf "%s" "$input" | ${pkgs.fzf}/bin/fzf \
          --prompt="$prompt" \
          --height=100% \
          --preview="echo {}" \
          --border > "$tmp"

        local result=""
        [[ -f "$tmp" ]] && result=$(cat "$tmp")
        rm -f "$tmp"

        echo "$result"
      }

      commit_file_with_diff() {
        local f="$1"
        local msgfile diff

        diff=$(git diff --cached --unified=0 --no-color -- "$f" \
          | sed \
            -e '/^diff --git /d' \
            -e '/^index /d' \
            -e '/^--- /d' \
            -e '/^\+\+\+ /d' \
            -e '/^@@ /d')

        msgfile=$(mktemp)

        {
          printf '%s - %s\n\n' "$sys_msg" "$timestamp"
          printf 'Update file: %s\n\n' "$f"
          printf 'Changes:\n'
          printf '%s\n' "$diff"
        } > "$msgfile"

        git commit -F "$msgfile"
        rm -f "$msgfile"
      }

      # ─── main ──────────────────────────────────────────────────────────────────
      ICON="$HOME/.config/Assets/Icons/rebuild.png"
      SOUND="$HOME/.config/Assets/Sounds/notification.wav"

      dir="$HOME/.dotfiles/racooonfig"
      timestamp=$(date "+%Y-%m-%d %H:%M")

      sys_msg="''${1:-"Update via SAVEFLAKE"}"
      current_branch=$(git -C "$dir" branch --show-current 2>/dev/null)
      target_branch="''${2:-$current_branch}"

      cd "$dir" || { echo "❌ Directory $dir tidak ditemukan!"; exit 1; }

      echo "🚀 Memproses dotfiles di $dir..."

      if [[ -n $(git status --porcelain) ]]; then
        git diff --name-only | while IFS= read -r f; do
          git add -- "$f"
          commit_file_with_diff "$f"
        done
        git add .
        git diff --cached --quiet || git commit -m "$timestamp | $sys_msg"
        sleep 0.1
        git push origin "$target_branch"
        echo "✅ Changes pushed to $target_branch dengan pesan: $sys_msg"
      else
        echo "⚡ Tidak ada perubahan di $dir."
        sleep 0.1
        git push origin "$target_branch"
      fi

      # ─── tanya rebuild ─────────────────────────────────────────────────────────
      printf '\nLanjut rebuild system? (y/n) '
      read -rn 1 res
      echo

      if [[ "$res" == "y" ]]; then
        cd "/etc/nixos" || { echo "❌ Directory system tidak ditemukan!"; exit 1; }

        host=$(tmux_fzf "$(printf "%s\n" \
          "infinix" \
          "wsl" \
          "macbook" \
          "vm-aarch64" | sort -u)" \
          "Pilih host (ctrl-c to cancel): ")

        [[ -z "$host" ]] && { echo "🛑 Rebuild dibatalkan, host tidak dipilih."; exit 1; }

        spec=$(tmux_fzf "$(printf "%s\n" \
          "none" \
          "gamemode")" \
          "Specialisation (ctrl-c to cancel): ")

        [[ -z "$spec" ]] && { echo "🛑 Rebuild dibatalkan, specialisation tidak dipilih."; exit 1; }

        echo "🔄 Updating Nix flake..."
        ${pkgs.nix}/bin/nix flake update racooonfig

        if [[ -n $(git status --porcelain) ]]; then
          git diff --name-only | while IFS= read -r f; do
            git add -- "$f"
            commit_file_with_diff "$f"
          done
          git add .
          git diff --cached --quiet || \
          git commit -m "$timestamp | Rebuild system ($host): $sys_msg"
        fi

        echo "🚀 Rebuilding NixOS untuk $host..."

        if [[ "$spec" == "none" ]]; then
          sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .#"$host"
        else
          sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch \
            --flake .#"$host" \
            --specialisation "$spec"
        fi

        echo "✅ System rebuild selesai!"

        if [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
          dunstify -i "$ICON" \
            -r 2002 \
            -u normal "Rebuild Done" "NixOS rebuild Switch" &
        else
          notify-send -i "$ICON" \
            -r 2002 \
            -u normal "Rebuild Done" "NixOS rebuild Switch" &
        fi
        canberra-gtk-play -f "$SOUND" -V 15.0 &
      else
        echo "🛑 Rebuild dibatalkan."
      fi
    '')
  ];
}
