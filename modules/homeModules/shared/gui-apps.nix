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
      ungoogled-chromium
      xarchiver
      gparted # Manage Disk Partition
      vivaldi
      ulauncher
      pavucontrol
      # font-manager
      # picard
      # protonvpn-gui
      # qbittorrent

      # Editor # Productivity
      zoom
      libreoffice
      evince # Document Viewer
      kdePackages.kdenlive
      audacity
      gimp
      gthumb
      # godot

      # CLI TOOLS
      ani-cli # butuh mpv(GUI) untuk streaming
      go-grip # Markdown Preview via http server: butuh browser
      spotdl

      # UTILS
      ffmpeg-full # absolutely need GUI
    ];
  };
}
