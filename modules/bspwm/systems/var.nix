{ ... }:

{
  systemd.tmpfiles.rules = [
    # Menggunakan grup wheel agar hanya admin yang bisa memodifikasi
    "d /usr/share/icons 0775 root wheel -"
    "d /usr/share/themes 0775 root wheel -"
  ];

  environment.variables = {
    XCURSOR_PATH = [
      "/usr/share/icons"
    ];

    XDG_DATA_DIRS = [
      "/usr/share"
    ];
  };
}
