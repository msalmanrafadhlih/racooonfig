{ config, lib }: let cfg = config.racooonfig;
in [
  # Spotify
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
  (lib.mkIf (builtins.elem "riff-flatpak" cfg.listConfigurations) {
    appId = "dev.diegovsky.Riff";
    origin = "flathub";
  })
]
