{
  imports = [
    ./popups/process-manager.nix
    ./popups/launch.nix
    ./popups/shortcuts.nix
  ];
  programs.tmux.extraConfig = ''
# 1. Main Menu
set-option -g command-alias[99] 'main-menu=display-menu -T "#[align=centre] 󰍜 Main Menu " -x C -y C \
  "-"                  -  "" \
  "  DevShell"        d  "devshell-menu" \
  "^  Launch"          l  "launch" \
  "❅  Flakes"          f  "flake-menu" \
  ">_ Scripts"         s  "scripts" \
  "📌 Notes"           n  "notes" \
  "♠  Keybinds"        ?  "shortcuts" \
  "-"                  -  "" \
  "❌ Quit"            q  ""'

# Launcher
set-option -g command-alias[104] 'launch=display-menu -T "#[align=centre] ^ Launch " -x C -y C \
  "-"                  -  "" \
  "file-manager"       1  "ranger" \
  "find & Replace"     2  "serpl" \
  "Scratchpad L"       3  "scratchpad" \
  "Scratchpad XL"      4  "scratchpad2" \
  "Youtube Downloader" 5  "xytz" \
  "Desktopify"         6  "display-popup -E 'desktopify-lite'" \
  "Process Manager"    7  "rip" \
  "LazyGit"            8  "lazygit" \
  "-"                  -  "" \
  "GeminiAI"           g  "gemini" \
  "AI-mate"            a  "mate" \
  "-"                  -  "" \
  "↩ Back"             b  "main-menu"'

# 2. DevShell Submenu Alias
set -g command-alias[0] 'devshell-menu=display-menu -T "#[align=centre]   DevShell " -x C -y C \
  "-"                  -  "" \
  "📱 Mobile Dev"      1  "new-session -d -s mobile -c ~/.repos/MobileDevelopment \; switch-client -t mobile" \
  "🦀 Rust Dev"        2  "new-session -d -s rust -c ~/.repos/RustDevelopment \; switch-client -t rust" \
  "🌐 Web Dev"         3  "new-session -d -s web -c ~/.repos/WebDevelopment \; switch-client -t web" \
  "-"                  -  "" \
  "↩ Back"             b  "main-menu"'
  
# 3. Flake Submenu Alias
set-option -g command-alias[101] 'flake-menu=display-menu -T "#[align=centre] 🖧 Configurations " -x C -y C \
  "-"                  -  "" \
  "🧩 System"          1  "display-popup -w 90% -h 90% -y C -T \"Flake System\" -E \"hx ~/.dotfiles/system/flake.nix\"" \
  "🏠 Home"            2  "display-popup -w 90% -h 90% -y C -T \"Flake Home\" -E \"hx ~/.dotfiles/bspwm/flake.nix\"" \
  "-"                  -  "" \
  "↩ Back"             b  "main-menu"'

# 4. Scripts Submenu Alias
set-option -g command-alias[102] 'scripts=display-menu -T "#[align=centre] ⚡ Scrpts " -x C -y C \
  "-"                  -  "" \
  "🧩 Aliases"         1  "display-popup -w 90% -h 90%  -y C -T \"Flake System\" -E \"$SHELL -ic ALIAS;read\"" \
  "-"                  -  "" \
  "↩ Back"             b  "main-menu"'

# 5. Notes
set-option -g command-alias[103] 'notes=display-menu -T "#[align=centre] 📌 Notes " -x C -y C \
  "Rust Learning"      r "new-window -n Rust -c ~/.repos/Learning/Rust \"hx .\"" \
  "NodeJS Learning"    n "new-window -n NodeJS -c ~/.repos/Learning/NodeJS \"hx .\"" \
  "↩ Back"             b "main-menu"' 

  bind m main-menu
  '';
}
