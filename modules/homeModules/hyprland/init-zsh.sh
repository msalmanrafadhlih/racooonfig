setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

qcopy() {
    # 1. Dependency Checks
    if ! command -v wl-copy &> /dev/null; then
        echo "Error: 'wl-copy' is not installed. Please install wl-clipboard."
        return 1
    fi

    if ! command -v fzf &> /dev/null; then
        echo "Error: 'fzf' is not installed. Please install fzf."
        return 1
    fi

    # Determine the best preview tool (use 'bat' if installed for syntax highlighting, otherwise 'cat')
    local PREVIEW_CMD="cat {}"
    if command -v bat &> /dev/null; then
        PREVIEW_CMD="bat --style=numbers --color=always {}"
    elif command -v batcat &> /dev/null; then
        PREVIEW_CMD="batcat --style=numbers --color=always {}"
    fi

    # 2. Run the TUI (fzf)
    # --multi: Allows selecting multiple files with TAB
    # --layout=reverse: Puts the prompt at the top
    local selected_files
    selected_files=$(find . -type f -not -path "*/\.git/*" 2>/dev/null | fzf --multi \
        --layout=reverse \
        --preview="$PREVIEW_CMD" \
        --preview-window=right:60%:wrap \
        --prompt="Select files > " \
        --header="Use ARROW KEYS to navigate. Press TAB to select files, ENTER to copy to clipboard, ESC to cancel.")

    # 3. Handle Exit/Cancel
    if [[ -z "$selected_files" ]]; then
        echo "No files selected. Exited qcopy."
        return 0
    fi

    # 4. Process and Format Selected Files
    local temp_file
    temp_file=$(mktemp)

    # Read the fzf output line by line safely (handles spaces in filenames)
    while IFS= read -r file; do
        # Remove the leading './' from the find output for cleaner paths
        local clean_file="${file#./}"

        # Format exactly as requested: File name followed by contents
        echo "file name: $clean_file" >> "$temp_file"
        echo "file contents:" >> "$temp_file"
        cat "$file" >> "$temp_file"
        echo -e "\n----------------------------------------\n" >> "$temp_file"
    done <<< "$selected_files"

    # 5. Copy to Clipboard
    cat "$temp_file" | wl-copy

    # 6. Success Output
    local file_count=$(echo "$selected_files" | wc -l)
    echo "Success! Copied $file_count file(s) to your Wayland clipboard. Ready to paste to your LLM."

    # 7. Cleanup
    rm -f "$temp_file"
}
 
pasteimg() {
    local name="${1:-clipboard.png}"
    [[ "$name" != *.png ]] && name="$name.png"
    wl-paste --type image/png | sudo tee "$name" > /dev/null
}

stsetup() {
    local proj_dir="$HOME/Projects/stewart-new"
    
    if [[ ! -d "$proj_dir" ]]; then
        echo "Directory $proj_dir does not exist."
        return 1
    fi

    cd "$proj_dir" || return 1

    kitty --directory "$proj_dir" nix develop --command zsh -ic "alias run='python main.py'; exec zsh" &
    
    sleep 0.5
    
    hyprctl dispatch splitratio -0.5

    nix develop --command zsh -ic "edit; exec zsh"
}

