{ pkgs,  ... }:
{
  environment.systemPackages = [
    pkgs.qylock-sddm-theme
    pkgs.cursor-memes
  ];

  services = {
    xserver = {
      enable = true;
      windowManager = {
        bspwm.enable = true;
      };
      autoRepeatDelay = 300;
      autoRepeatInterval = 35;
    };

    displayManager = {
      # SDDM
      sddm = {
        enable = true;
        theme = "orbital";
        setupScript = ''
          ${pkgs.xrdb}/bin/xrdb -merge - <<EOF
          Xcursor.theme: Skyrim-by-ru5tyshark-cursors
          Xcursor.size: 32
          EOF
        '';

        # PENTING: SDDM butuh ini agar module QML terbaca oleh greeter
        # Tambahkan paket tema dan dependensi QML yang wajib
        extraPackages = [
          pkgs.kdePackages.qtmultimedia
          pkgs.kdePackages.qt5compat
          pkgs.kdePackages.qtsvg
          pkgs.kdePackages.qtdeclarative # qt6-declarative di dokumen

          # GStreamer Plugins (Wajib untuk video background di qylock)
          pkgs.gst_all_1.gst-plugins-base
          pkgs.gst_all_1.gst-plugins-good
          pkgs.gst_all_1.gst-plugins-bad
          pkgs.gst_all_1.gst-plugins-ugly
          pkgs.gst_all_1.gst-libav
        ];
      };
    };
  };
}
