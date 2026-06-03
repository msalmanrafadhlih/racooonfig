{ config, lib }: let cfg = config.racooonfig;
in [
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

  # plasma addons
  (lib.mkIf (builtins.elem "macos-kdeplasma-apps" cfg.listConfigurations) {
    # Music player
    appId = "io.bassi.Amberol";
    origin = "flathub";
  }{
    # Dowload Manager
    appId = "net.agalwood.Motrix";
    origin = "flathub";
  }{
    # Listen to Ambient sound
    appId = "com.rafaelmardojai.Blanket";
    origin = "flathub";
  }{
    # Another Spotify Client
    appId = "com.github.KRTirtho.Spotube";
    origin = "flathub";
  })
]
