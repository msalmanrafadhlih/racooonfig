{ pkgs, inputs, system, ... }:
{

  # GUI Apps
  programs = {
    obs-studio.enable = true;
  };

  home.packages = with pkgs; [
    ungoogled-chromium
    vivaldi
    # gimp
    timg
    zoom
    libreoffice
    evince # Document Viewer
    xarchiver
    gparted # Manage Disk Partition
    vesktop
    # font-manager
    # picard
    # godot
    # protonvpn-gui
    # qbittorrent

    # CLI TOOLS
    ani-cli # butuh mpv(GUI) untuk streaming
    go-grip # Markdown Preview via http server: butuh browser

    # UTILS
    ffmpeg-full # absolutely need GUI
    inputs.st-nix.packages.${system}.default
  ];
}
