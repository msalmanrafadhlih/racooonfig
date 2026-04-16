{ ... }:
{
  xdg.mimeApps = { 
    enable = true;

    # Aplikasi default untuk jenis MIME tertentu
    defaultApplications = {
      "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];

      "application/octet-stream" = [ "geany.desktop" ];
      "image/png" = [ "com.interversehq.qView.desktop" ];
      "image/jpeg" = [ "com.interversehq.qView.desktop" ];
      "image/svg+xml" = [ "com.interversehq.qView.desktop" ];
      "application/x-zerosize" = [ "geany.desktop" ];
  	  "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };

    # Asosiasi tambahan (tidak menggantikan default)
#    associations.added = {
#      "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
#      "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];
#      "application/octet-stream" = [ "geany.desktop" ];
#      "image/gif" = [ "com.interversehq.qView.desktop" ];
#      "image/png" = [ "com.interversehq.qView.desktop" ];
#      "image/jpeg" = [ "com.interversehq.qView.desktop" ];
#      "image/svg+xml" = [ "com.interversehq.qView.desktop" ];
#      "application/x-zerosize" = [ "geany.desktop" ];
#    };

    # Kamu juga bisa hapus asosiasi tertentu (optional)
    associations.removed = { };
  };
}
