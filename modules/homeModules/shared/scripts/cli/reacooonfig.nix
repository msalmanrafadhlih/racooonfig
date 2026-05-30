{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "RACOOON" ''
      #!${pkgs.zsh}/bin/zsh

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

      # ─── main ──────────────────────────────────────────────────────────────────
      dir="$HOME/.dotfiles/racooonfig"
      timestamp=$(date "+%Y-%m-%d %H:%M")

      sys_msg="''${1:-"Update via SAVEFLAKE"}"
      current_branch=$(git -C "$dir" branch --show-current 2>/dev/null)
      target_branch="''${2:-$current_branch}"

      cd "$dir" || { echo "❌ Directory $dir tidak ditemukan!"; exit 1; }

      echo "🚀 Memproses dotfiles di $dir..."

      if [[ -n $(git status --porcelain) ]]; then
        # Commit setiap file yang berubah secara individual, lalu commit sisanya
        git diff --name-only | while IFS= read -r f; do
          git add -- "$f"
          git commit -m "$timestamp | $sys_msg: $f"
        done
        # Tangani file baru / untracked yang belum ter-add
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
      echo -n "\nLanjut rebuild system? (y/n) "
      read -k 1 res
      echo

      if [[ "$res" == "y" ]]; then
        cd "/etc/nixos" || { echo "❌ Directory system tidak ditemukan!"; exit 1; }

        # === host selection ===
        host=$(tmux_fzf "$(printf "%s\n" \
          "infinix" \
          "wsl" \
          "macbook" \
          "vm-aarch64" | sort -u)" \
          "Pilih host (ctrl-c to cancel): ")

        [[ -z "$host" ]] && { echo "🛑 Rebuild dibatalkan, host tidak dipilih."; exit 1; }

        # === specialisation ===
        spec=$(tmux_fzf "$(printf "%s\n" \
          "gamemode" \
          "none")" \
          "Specialisation (ctrl-c to cancel): ")

        [[ -z "$spec" ]] && { echo "🛑 Rebuild dibatalkan, specialisation tidak dipilih."; exit 1; }

        echo "🔄 Updating Nix flake..."
        ${pkgs.nixFlakes}/bin/nix flake update racooonfig

        if [[ -n $(git status --porcelain) ]]; then
          git diff --name-only | while IFS= read -r f; do
            git add -- "$f"
            git commit -m "$timestamp | $sys_msg: $f"
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
      else
        echo "🛑 Rebuild dibatalkan."
      fi
    '')
  ];
}
