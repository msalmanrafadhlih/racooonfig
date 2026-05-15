{ ... }:
{
  xdg.mimeApps = { 
    enable = true;

    # Aplikasi default untuk jenis MIME tertentu
    defaultApplications = let
      imageViewer = [ "com.interversehq.qView.desktop" "org.gnome.gThumb.desktop" "feh.desktop" "gimp.desktop" ];
      textEditor  = [ "geany.desktop" "Helix.desktop" "dev.zed.Zed.desktop" ];
      browser     = [ "vivaldi-stable.desktop" "chromium-browser.desktop" ];
      pdfViewer   = [ "org.gnome.Evince.desktop" ];
    
    in {
      # Browser
      "x-scheme-handler/http"   = browser;
      "x-scheme-handler/https"  = browser;
      "x-scheme-handler/ftp"    = browser;
      "text/html"               = browser;

      # Images — semua format umum
      "image/png"               = imageViewer;
      "image/jpeg"              = imageViewer;
      "image/jpg"               = imageViewer;
      "image/gif"               = imageViewer;  # ← INI yang hilang!
      "image/webp"              = imageViewer;
      "image/svg+xml"           = imageViewer;
      "image/bmp"               = imageViewer;
      "image/tiff"              = imageViewer;
      "image/x-portable-pixmap" = imageViewer;
      "image/avif"              = imageViewer;
      "image/heic"              = imageViewer;

      # Text / Code
      "text/plain"              = textEditor;
      "text/x-shellscript"      = textEditor;
      "application/json"        = textEditor;
      "application/x-zerosize"  = textEditor;   # empty file
      "application/octet-stream"= textEditor;

      # PDF / Dokumen
      "application/pdf"         = pdfViewer;
    };

    # Aktifkan ini! Ini penting untuk fallback
    associations.added = {
      "image/png"  = [ "org.gnome.gThumb.desktop" "feh.desktop" "gimp.desktop" ];
      "image/jpeg" = [ "org.gnome.gThumb.desktop" "feh.desktop" "gimp.desktop" ];
      "image/gif"  = [ "org.gnome.gThumb.desktop" "feh.desktop" ];
      "image/webp" = [ "org.gnome.gThumb.desktop" "feh.desktop" ];
    };

    # Kamu juga bisa hapus asosiasi tertentu (optional)
    associations.removed = { };
  };
}
