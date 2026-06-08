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

        MUSIC_DIR="$HOME/Musics"
        UNTAGGED_DIR="$MUSIC_DIR/Untaged musics"
        PLAYLIST_DIR="$MUSIC_DIR/Playlists"

        mkdir -p "$UNTAGGED_DIR"
        mkdir -p "$PLAYLIST_DIR"

        if [[ $# -eq 0 ]]; then
          echo "Usage:"
          echo "  dmusic <youtube-url>"
          echo "  dmusic playlist <playlist-url>"
          exit 1
        fi

        YTDLP_COMMON=(
          --extract-audio
          --audio-format m4a
          --audio-quality 0
          --embed-thumbnail
          --embed-metadata
          --parse-metadata 'playlist_index:%(track_number)s'
          --format 'ba/best'
          --retry-sleep 3
          --retries infinite
          --sleep-interval 2
          --max-sleep-interval 5
          --download-archive "$HOME/Musics/downloaded_archive.txt"
          --extractor-args 'youtube:player_client=android,web'
          --restrict-filenames
          --windows-filenames
        )

        if [[ "$1" == "playlist" ]]; then
          [[ $# -lt 2 ]] && { echo "Playlist URL required"; exit 1; }
          URL="$2"

          if ! yt-dlp \
            "''${YTDLP_COMMON[@]}" \
            --output "$PLAYLIST_DIR/%(playlist_title)s/%(playlist_index)s_-_%(title)s.%(ext)s" \
            "$URL"; then
            echo "[WARNING] Some tracks may have failed, continuing..."
          fi

          echo "[beets] Importing playlist..."
          beet import -q "$PLAYLIST_DIR"

        else
          URL="$1"

          if ! yt-dlp \
            "''${YTDLP_COMMON[@]}" \
            --no-playlist \
            --output "$UNTAGGED_DIR/%(title)s.%(ext)s" \
            "$URL"; then
            echo "[WARNING] Download may have had issues, continuing..."
          fi

          echo "[beets] Importing music..."
          beet import -q "$UNTAGGED_DIR"
        fi

        echo "[beets] Fetching artwork..."
        beet fetchart added:-1d..

        echo "[beets] Fetching lyrics..."
        beet lyrics added:-1d..

        echo "Done."
      '';
    })
  ];
}
