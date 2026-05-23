{ lib, config, ... }:
let
  cfg = config.racooonfig;
in

{
  config = lib.mkIf (cfg.homeManager && builtins.elem "bspwm" cfg.listConfigurations) {
    xdg.mimeApps = {
      enable = true;

      # Aplikasi default untuk jenis MIME tertentu
      defaultApplications =
        let
          imageViewer = [
            "com.interversehq.qView.desktop"
            "org.gnome.gThumb.desktop"
            "feh.desktop"
            "gimp.desktop"
          ];
          textEditor = [
            "geany.desktop"
            "Helix.desktop"
            "dev.zed.Zed.desktop"
          ];

          browser = [
            "vivaldi-stable.desktop"
            "chromium-browser.desktop"
          ];

          # media
          audioPlayer = [
            "mpv.desktop"
            "audacity.desktop"
          ];
          videoPlayer = [
            "mpv.desktop"
            "org.kde.kdenlive.desktop"
          ];

          # Document
          pdfViewer = [ "org.gnome.Evince.desktop" ];

        in
        {
          # Browser
          "x-scheme-handler/vivaldi" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/ftp" = browser;
          "text/html" = browser;

          # Images — semua format umum
          "image/png" = imageViewer;
          "image/jpeg" = imageViewer;
          "image/jpg" = imageViewer;
          "image/gif" = imageViewer;
          "image/webp" = imageViewer;
          "image/svg+xml" = imageViewer;
          "image/bmp" = imageViewer;
          "image/tiff" = imageViewer;
          "image/x-portable-pixmap" = imageViewer;
          "image/avif" = imageViewer;
          "image/heic" = imageViewer;

          # Text / Code / XML
          "text/plain" = textEditor;
          "text/x-shellscript" = textEditor;
          "application/json" = textEditor;
          "application/xml" = textEditor; # Tambahan XML
          "text/xml" = textEditor; # Tambahan XML
          "application/x-zerosize" = textEditor;
          "application/octet-stream" = textEditor;
          "application/x-shellscript" = textEditor;
          "text/x-script" = textEditor;

          # PDF / Dokumen
          "application/pdf" = pdfViewer;

          # Audio
          "audio/mp3" = audioPlayer;
          "audio/opus" = audioPlayer;
          "audio/webm" = audioPlayer;
          "audio/mpeg" = audioPlayer; # MP3
          "audio/x-wav" = audioPlayer; # WAV
          "audio/wav" = audioPlayer;
          "audio/ogg" = audioPlayer; # OGG
          "audio/x-ogg" = audioPlayer;
          "audio/flac" = audioPlayer; # FLAC
          "audio/aac" = audioPlayer; # AAC
          "audio/mp4" = audioPlayer; # M4A/MP4 Audio
          "audio/x-m4a" = audioPlayer;
          "audio/x-matroska" = audioPlayer; # MKA
          "audio/x-ms-wma" = audioPlayer;
          "application/ogg" = audioPlayer;

          # Video
          "video/mp4" = videoPlayer;
          "video/x-matroska" = videoPlayer;
          "video/webm" = videoPlayer;
          "video/x-msvideo" = videoPlayer;
          "video/quicktime" = videoPlayer; # video (MPV)

        };

      # Aktifkan ini! Ini penting untuk fallback
      associations.added = {
        "image/png" = [
          "org.gnome.gThumb.desktop"
          "feh.desktop"
          "gimp.desktop"
        ];
        "image/jpeg" = [
          "org.gnome.gThumb.desktop"
          "feh.desktop"
          "gimp.desktop"
        ];
        "image/gif" = [
          "org.gnome.gThumb.desktop"
          "feh.desktop"
        ];
        "image/webp" = [
          "org.gnome.gThumb.desktop"
          "feh.desktop"
        ];
      };

      # Kamu juga bisa hapus asosiasi tertentu (optional)
      associations.removed = { };
    };
  };
}
