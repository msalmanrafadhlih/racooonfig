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
      # telegram-desktop
      # ungoogled-chromium
      # vivaldi
      # gthumb
      # font-manager
      # picard
      # protonvpn-gui
      # qbittorrent

      # ======================
      # Editor # Productivity
      # ======================
      # gimp
      zoom
      # evince # Document Viewer
      libreoffice
      obsidian
      # kdePackages.kdenlive
      # audacity
      # godot

      # =====================
      # TOOLS
      # ====================
      # xarchiver
      # gparted # Manage Disk Partition
      # pavucontrol
      # ulauncher
      # Cli =========
      # ffmpeg-full # absolutely need GUI
      # ani-cli # butuh mpv(GUI) untuk streaming
      # go-grip # Markdown Preview via http server: butuh browser
      # spotdl
    ];
  };
}
