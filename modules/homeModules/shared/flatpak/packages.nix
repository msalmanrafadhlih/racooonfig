{ config, lib, ... }:
let
  cfg = config.racooonfig;
  enableMacOsKdeApps = builtins.elem "macos-kdeplasma-apps" cfg.listConfigurations;
in
[
  # Spotify original
  (lib.mkIf (builtins.elem "spotify-flatpak" cfg.listConfigurations) {
    appId = "com.spotify.Client";
    origin = "flathub";
  })

  # zen browser
  (lib.mkIf (builtins.elem "zen-flatpak" cfg.listConfigurations) {
    appId = "app.zen_browser.zen";
    origin = "flathub";
  })

  # spotify Clint for Gnome desktop
  # Note: Riff require premium account
  (lib.mkIf (builtins.elem "riff-flatpak" cfg.listConfigurations) {
    appId = "dev.diegovsky.Riff";
    origin = "flathub";
  })

  # Whatsapp Client
  (lib.mkIf (builtins.elem "whatsapp-flatpak" cfg.listConfigurations) {
    appId = "com.rtosta.zapzap";
    origin = "flathub";
  })

  # Zoom - Video Conferencing
  (lib.mkIf (builtins.elem "zoom-flatpak" cfg.listConfigurations) {
    appId = "us.zoom.Zoom";
    origin = "flathub";
  })

  # plasma addons - Music player
  (lib.mkIf (builtins.elem "amberol-flatpak" cfg.listConfigurations) {
    appId = "io.bassi.Amberol";
    origin = "flathub";
  })

  # plasma addons - Download Manager
  (lib.mkIf (builtins.elem "motrix-flatpak" cfg.listConfigurations) {
    appId = "net.agalwood.Motrix";
    origin = "flathub";
  })

  # plasma addons - Listen to Ambient sound
  (lib.mkIf (builtins.elem "blanket-flatpak" cfg.listConfigurations) {
    appId = "com.rafaelmardojai.Blanket";
    origin = "flathub";
  })

  # plasma addons - Another Spotify Client
  (lib.mkIf (builtins.elem "spotube-flatpak" cfg.listConfigurations) {
    appId = "com.github.KRTirtho.Spotube";
    origin = "flathub";
  })
]
