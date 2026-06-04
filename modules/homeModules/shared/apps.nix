{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.home;
in
{
  config = lib.mkIf (cfg.username == "tquilla") {
    # GUI Apps
    programs = {
      obs-studio.enable = true;
    };

    home.packages = with pkgs; [
      # ======================
      # Media # Browser
      # ======================
      vlc
      # telegram-desktop
      # ungoogled-chromium
      # vivaldi
      # gthumb
      whatsie
      # font-manager
      # picard
      # protonvpn-gui
      # qbittorrent

      # ======================
      # Editor # Productivity
      # ======================
      # gimp
      # evince # Document Viewer
      libreoffice-qt-still
      obsidian
      # kdePackages.kdenlive
      # audacity
      # godot

      # =====================
      # TOOLS
      # ====================
      kando # Pie-Menu
      # xarchiver
      # gparted # Manage Disk Partition
      # pavucontrol
      # albert # launcher

      # Cli =========
      # ffmpeg-full # absolutely need GUI
      # ani-cli # butuh mpv(GUI) untuk streaming
      go-grip # Markdown Preview via http server: butuh browser
      nchat
      # spotdl
    ];
  };
}
