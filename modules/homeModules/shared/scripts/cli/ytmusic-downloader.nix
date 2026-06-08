{ pkgs, ... }:
{
  environment.systemPackages = [
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

        # PENTING: Pindahkan folder unduhan mentah ke luar folder ~/Musics untuk mencegah konflik pemindahan file
        UNTAGGED_DIR="/tmp/dmusic-downloads"
        PLAYLIST_DIR="$HOME/Musics/Playlists"

        mkdir -p "$UNTAGGED_DIR"
        mkdir -p "$PLAYLIST_DIR"

        if [[ $# -eq 0 ]]; then
          echo "Usage:"
          echo "  dmusic <youtube-url>"
          echo "  dmusic playlist <playlist-url>"
          exit 1
        fi

        if [[ "$1" == "playlist" ]]; then
          [[ $# -lt 2 ]] && {
            echo "Playlist URL required"
            exit 1
          }

          URL="$2"

          # Mengunduh lagu playlist ke folder sementara
          yt-dlp \
            --extract-audio \
            --audio-format opus \
            --audio-quality 0 \
            --embed-thumbnail \
            --embed-metadata \
            --parse-metadata 'playlist_index:%(track_number)s' \
            --format 'ba/best' \
            --ignore-errors \
            --retry-sleep 3 \
            --retries infinite \
            --download-archive "$HOME/Musics/downloaded_archive.txt" \
            --output "$PLAYLIST_DIR/%(playlist)s/%(title)s.%(ext)s" \
            --extractor-args 'youtube:player_client=android' \
            --restrict-filenames \
            --yes-playlist \
            --windows-filenames \
            "$URL"
        else

          URL="$1"

          # Mengunduh lagu single ke folder sementara
          yt-dlp \
            --no-playlist \
            --extract-audio \
            --audio-format opus \
            --audio-quality 0 \
            --embed-thumbnail \
            --embed-metadata \
            --parse-metadata 'playlist_index:%(track_number)s' \
            --format 'ba/best' \
            --retry-sleep 3 \
            --retries infinite \
            --download-archive "$HOME/Musics/downloaded_archive.txt" \
            --output "$UNTAGGED_DIR/%(title)s.%(ext)s" \
            --extractor-args 'youtube:player_client=android' \
            --restrict-filenames \
            --windows-filenames \
            "$URL"

          echo
          echo "[beets] Memulai proses auto-tagging lagu..."
          beet import -qA "$UNTAGGED_DIR"
        fi

        echo
        echo "Selesai! File musik Anda telah dirapikan ke dalam folder ~/Musics"
      '';
    })
  ];
}
