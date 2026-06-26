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
      browser="chromium --user-data-dir=$HOME/.config/Chromium"

      case "$1" in
        --gemini)
          url="https://gemini.google.com"
          class="GeminiAi"
          echo "Opening $url..."
          exec $browser --app="$url" --class="$class"
          ;;

        --claude)
          url="https://claude.ai"
          class="ClaudeAi"
          echo "Opening $url..."
          exec $browser --app="$url" --class="$class"
          ;;

        --chatgpt)
          url="https://chat.openai.com"
          class="ChatAi"
          echo "Opening $url..."
          exec $browser --app="$url" --class="$class"
          ;;

        *)
          cat <<EOF
      Usage:
        openapp --gemini
        openapp --claude
        openapp --chatgpt
      EOF
          exit 1
          ;;
      esac
    '';
  };
in
{
  config = lib.mkIf config.racooonfig.homeManager {
    home.packages = [ openapp ];
  };
}
