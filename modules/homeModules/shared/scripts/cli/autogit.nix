{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "SAVEFLAKE";
      runtimeInputs = [
        pkgs.fzf
        pkgs.git
        pkgs.coreutils
      ];
      text = ''
        # ─── Helper Functions ────────────────────────────────────────────────────────
        commit_file_with_diff() {
            local f="$1"
            local msgfile diff

            diff=$(git diff --cached --unified=0 --no-color -- "$f" |
                sed \
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

        dir="."
        timestamp=$(date "+%Y-%m-%d %H:%M")

        sys_msg="''${"1:-Update" via SAVEFLAKE}"
        current_branch=$(git -C "$dir" branch --show-current 2> /dev/null)
        target_branch="${"2:-$current_branch"}"

        if [[ ! -n "$current_branch" ]]; then
            echo "no git in thios folder"
            exit 0
        fi

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
      '';
    })
  ];
}
