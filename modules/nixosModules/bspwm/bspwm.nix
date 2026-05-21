{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.qylock-sddm-theme
    pkgs.cursor-memes
  ];

  services = {
    xserver = {
      enable = lib.mkDefault true;
      windowManager = {
        bspwm.enable = lib.mkDefault true;
      };
      autoRepeatDelay = lib.mkDefault 300;
      autoRepeatInterval = lib.mkDefault 35;
    };

    displayManager = {
      # SDDM
      sddm = {
        enable = lib.mkDefault true;
        theme = lib.mkDefault "orbital";
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
