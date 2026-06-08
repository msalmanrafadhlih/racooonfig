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

        RANDOM_ID=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8)
        MUSIC_DIR="$HOME/Musics"
        UNTAGGED_DIR="/tmp/dmusics-downloads-$RANDOM_ID"

        mkdir -p "$UNTAGGED_DIR"
        mkdir -p "$MUSIC_DIR"

        if [[ $# -eq 0 ]]; then
          echo "Usage:"
          echo "  dmusic <youtube-url>"
          echo "  dmusic playlist <playlist-url>"
          exit 1
        fi

        if [[ "$1" == "playlist" ]]; then
          if [[ $# -lt 2 ]]; then
            echo "Error: Playlist URL required"
            exit 1
          fi

          URL="$2"

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

          echo "[beets] Memulai proses auto-tagging playlist..."
          # Menggunakan flag -g (group/as-is) atau -A (jangan tag sebagai album utuh jika meleset) agar beets berjalan otomatis
          beet import -q "$UNTAGGED_DIR"
        else

          URL="$1"

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

          echo "[beets] Memulai proses auto-tagging lagu..."
          beet import -q "$UNTAGGED_DIR"
        fi

        echo "[beets] Memperbarui database musik..."
        beet update

        # Hapus folder temporary beserta sisa file sampah (seperti sisa gambar thumbnail)
        rm -rf "$UNTAGGED_DIR"
        echo "Selesai! File musik Anda telah dirapikan ke dalam folder ~/Musics"
      '';
    })
  ];
}
