{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "dmusic";

      runtimeInputs = with pkgs; [
        yt-dlp
        ffmpeg
        beets
        chromaprint
        coreutils
        gnugrep
        findutils
      ];

      text = ''
        set -euo pipefail

        # Default variables
        COMP_ARGS=()
        IS_PLAYLIST=0
        URL=""

        # Simple Argument Parser
        while [[ $# -gt 0 ]]; do
          case $1 in
            --comp)
              COMP_ARGS=(--set comp=1 --noautotag)
              shift
              ;;
            playlist)
              IS_PLAYLIST=1
              shift
              ;;
            *)
              URL="$1"
              shift
              ;;
          esac
        done

        if [[ -z "$URL" ]]; then
          echo "Usage:"
          echo "  dmusic [--comp] <youtube-url>"
          echo "  dmusic [--comp] playlist <playlist-url>"
          exit 1
        fi

        MUSIC_DIR="$HOME/Musics"

        UNTAGGED_DIR=$(mktemp -d -t dmusic-XXXXXXX)

        trap 'rm -rf "$UNTAGGED_DIR"' EXIT

        mkdir -p "$MUSIC_DIR"

        if [[ $IS_PLAYLIST -eq 1 ]]; then
          echo "[yt-dlp] Mengunduh playlist ke folder sementara..."
          yt-dlp \
            --extract-audio \
            --audio-format m4a \
            --audio-quality 0 \
            --format 'ba/best' \
            --ignore-errors \
            --retry-sleep 3 \
            --retries infinite \
            --embed-thumbnail \
            --embed-metadata \
            --parse-metadata "playlist_title:%(album)s" \
            --parse-metadata "playlist_index:%(track_number)s" \
            --download-archive "$MUSIC_DIR/downloaded_archive.txt" \
            --output "$UNTAGGED_DIR/%(playlist)s/%(title)s.%(ext)s" \
            --extractor-args 'youtube:player_client=android' \
            --restrict-filenames \
            --yes-playlist \
            --windows-filenames \
            "$URL"
        else
          echo "[yt-dlp] Mengunduh lagu tunggal..."
          yt-dlp \
            --no-playlist \
            --extract-audio \
            --audio-format m4a \
            --audio-quality 0 \
            --embed-thumbnail \
            --embed-metadata \
            --format 'ba/best' \
            --retry-sleep 3 \
            --retries infinite \
            --download-archive "$MUSIC_DIR/downloaded_archive.txt" \
            --output "$UNTAGGED_DIR/%(title)s.%(ext)s" \
            --extractor-args 'youtube:player_client=android' \
            --restrict-filenames \
            --windows-filenames \
            "$URL"
        fi

        echo "[beets] Memulai proses auto-tagging..."
        beet import -q "''${COMP_ARGS[@]}" "$UNTAGGED_DIR"

        echo "[beets] Memperbarui database musik..."
        beet update

        echo "Selesai! File musik Anda telah dirapikan ke dalam folder ~/Musics"
      '';
    })
  ];
}
