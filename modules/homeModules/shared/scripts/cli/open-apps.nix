{
  pkgs,
  config,
  lib,
  ...
}:

let
  openapp = pkgs.writeShellApplication {
    name = "openapp";

    text = ''
      set -euo pipefail

      browser=(chromium --user-data-dir="$HOME/.config/Chromium")

      help() {
        echo "Usage:"
        echo "  openapp [--comp]"
        echo "  comp: gemini, claude, chatgpt"
        exit 1
      }

      if [[ -z "''${1:-}" ]]; then
        help
      fi

      case "$1" in
        --gemini)
          url="https://gemini.google.com"
          class="GeminiAi"
          echo "Opening $url..."
          exec "''${browser[@]}" --app="$url" --class="$class"
          ;;

        --claude)
          url="https://claude.ai"
          class="ClaudeAi"
          echo "Opening $url..."
          exec "''${browser[@]}" --app="$url" --class="$class"
          ;;

        --chatgpt)
          url="https://chat.openai.com"
          class="ChatAi"
          echo "Opening $url..."
          exec "''${browser[@]}" --app="$url" --class="$class"
          ;;

        *)
          help
          ;;
      esac
    '';
  };
in
{
  config = lib.mkIf config.racooonfig.homeManager {
    home.packages = with pkgs; [
      openapp
      chromium
    ];
  };
}
