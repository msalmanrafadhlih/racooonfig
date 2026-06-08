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

        # PENTING: Pindahkan folder unduhan mentah ke luar folder ~/Musics untuk mencegah konflik pemindahan file
        RANDOM_ID=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8)
        MUSIC_DIR="$HOME/Musics"

        UNTAGGED_DIR="/tmp/dmusics-downloads-$RANDOM_ID"
        PLAYLIST_DIR="$MUSIC_DIR/Playlists"

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
            --audio-format mp3 \
            --audio-quality 0 \
            --format 'ba/best' \
            --ignore-errors \
            --retry-sleep 3 \
            --retries infinite \
            --embed-thumbnail \
            --embed-metadata \
            --parse-metadata 'playlist_index:%(track_number)s' \
            --download-archive "$HOME/Musics/downloaded_archive.txt" \
            --output "$UNTAGGED_DIR/%(playlist)s/%(title)s.%(ext)s" \
            --extractor-args 'youtube:player_client=android' \
            --restrict-filenames \
            --yes-playlist \
            --windows-filenames \
            "$URL"

          echo "[beets] Memulai proses auto-tagging lagu..."
          beet import "$UNTAGGED_DIR"
        else

          URL="$1"

          # Mengunduh lagu single ke folder sementara
          yt-dlp \
            --no-playlist \
            --extract-audio \
            --audio-format mp3 \
            --audio-quality 0 \
            --embed-thumbnail \
            --embed-metadata \
            --parse-metadata "%(artist)s:%(artist)s" \
            --parse-metadata "%(track)s:%(title)s" \
            --format 'ba/best' \
            --retry-sleep 3 \
            --retries infinite \
            --download-archive "$HOME/Musics/downloaded_archive.txt" \
            --output "$UNTAGGED_DIR/%(title)s.%(ext)s" \
            --extractor-args 'youtube:player_client=android' \
            --restrict-filenames \
            --windows-filenames \
            "$URL"

          echo "[beets] Memulai proses auto-tagging lagu..."
          beet import "$UNTAGGED_DIR"
        fi

        beet update
        # Hapus folder temporary yang sudah kosong setelah dipindahkan oleh beets
        # rmdir "$UNTAGGED_DIR" 2>/dev/null || true
        echo "Selesai! File musik Anda telah dirapikan ke dalam folder ~/Musics"
      '';
    })
  ];
}
