{ lib, config, ... }:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf cfg.homeManager {
    home.file.".config/mimeapps.list".force = true;
    xdg.mimeApps = {
      enable = true;

      defaultApplications =
        let
          imageViewer = [
            "org.kde.gwenview.desktop"
            "com.interversehq.qView.desktop"
            "org.gnome.gThumb.desktop"
            "feh.desktop"
            "gimp.desktop"
          ];

          filemanager = [
            "org.gnome.Nautilus.desktop"
            "org.kde.dolphin.desktop"
            "thunar.desktop"
            "yazi.desktop"
          ];
          
          textEditor = [
            "kate.desktop"
            "org.kde.kate.desktop"
            "kwrite.desktop"
            "geany.desktop"
            "Helix.desktop"
            "dev.zed.Zed.desktop"
          ];

          browser = [
            "app.zen_browser.zen.desktop"
            "org.kde.falkon.desktop"
            "vivaldi-stable.desktop"
            "chromium-browser.desktop"
          ];

          audioPlayer = [
            "org.kde.elisa.desktop"
            "mpv.desktop"
            "audacity.desktop"
          ];

          videoPlayer = [
            "org.kde.haruna.desktop"
            "org.kde.dragonplayer.desktop"
            "mpv.desktop"
            "org.kde.kdenlive.desktop"
          ];

          pdfViewer = [
            "org.kde.okular.desktop"
            "org.gnome.Evince.desktop"
          ];
        in
        {

          # Browser
          "application/x-extension-htm" = browser;
          "application/x-extension-html" = browser;
          "application/x-extension-shtml" = browser;
          "application/x-extension-xht" = browser;
          "application/x-extension-xhtml" = browser;
          "x-scheme-handler/chrome" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/ftp" = browser;
          "application/xhtml+xml" = browser;
          "text/html" = browser;

          # filemanager
          "inode/directory" = filemanager;

          # Images
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
          "application/xml" = textEditor;
          "text/xml" = textEditor;
          "application/x-zerosize" = textEditor;
          "application/x-shellscript" = textEditor;
          "text/x-script" = textEditor;

          # PDF
          "application/pdf" = pdfViewer;

          # Audio
          "audio/mp3" = audioPlayer;
          "audio/opus" = audioPlayer;
          "audio/webm" = audioPlayer;
          "audio/mpeg" = audioPlayer;
          "audio/x-wav" = audioPlayer;
          "audio/wav" = audioPlayer;
          "audio/ogg" = audioPlayer;
          "audio/x-ogg" = audioPlayer;
          "audio/flac" = audioPlayer;
          "audio/aac" = audioPlayer;
          "audio/mp4" = audioPlayer;
          "audio/x-m4a" = audioPlayer;
          "audio/x-matroska" = audioPlayer;
          "audio/x-ms-wma" = audioPlayer;
          "application/ogg" = audioPlayer;

          # Video
          "video/mp4" = videoPlayer;
          "video/x-matroska" = videoPlayer;
          "video/webm" = videoPlayer;
          "video/x-msvideo" = videoPlayer;
          "video/quicktime" = videoPlayer;
        };

      associations.added = {
        "image/png" = [
          "org.kde.gwenview.desktop"
          "com.interversehq.qView.desktop"
          "org.gnome.gThumb.desktop"
          "feh.desktop"
          "gimp.desktop"
        ];
        "image/jpeg" = [
          "org.kde.gwenview.desktop"
          "com.interversehq.qView.desktop"
          "org.gnome.gThumb.desktop"
          "feh.desktop"
          "gimp.desktop"
        ];
        "image/gif" = [
          "org.kde.gwenview.desktop"
          "org.gnome.gThumb.desktop"
          "feh.desktop"
        ];
        "image/webp" = [
          "org.kde.gwenview.desktop"
          "org.gnome.gThumb.desktop"
          "feh.desktop"
        ];
      };
      associations.removed = { };
    };
  };
}
