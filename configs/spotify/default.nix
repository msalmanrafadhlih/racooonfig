{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "spotify" cfg.listConfigurations) {
    home.packages = [ pkgs.spicetify-cli ];

    home.activation = {
      setupSpicetifyFlatpak = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # Tentukan path (sesuaikan username jika perlu)
        SPOTIFY_PATH="$HOME/.local/share/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify"
        PREFS_PATH="$HOME/.config/spotify/prefs"
        SPICETIFY="${pkgs.spicetify-cli}/bin/spicetify"

        # Pastikan Spotify sudah terinstall sebelum lanjut
        if [ -d "$SPOTIFY_PATH" ]; then
          # Beri izin tulis (Flatpak user-level biasanya sudah punya izin, tapi amankan saja)
          chmod a+wr "$SPOTIFY_PATH"
          chmod a+wr -R "$SPOTIFY_PATH/Apps"

          # Konfigurasi Spicetify secara otomatis
          $SPICETIFY config spotify_path "$SPOTIFY_PATH"
          $SPICETIFY config prefs_path "$PREFS_PATH"
          
          # Jalankan apply secara otomatis (opsional)
          # $SPICETIFY apply
        fi
      '';
    };

    services.spotifyd = {
      enable = true;
      package = pkgs.spotifyd;
      settings = {
        global = {
          username_cmd = "cat ~/.config/spotify/username";
          password_cmd = "cat ~/.config/spotify/credentials";
          backend = "alsa"; # atau "alsa" kalau kamu pakai ALSA saja
          use_mpris = true;
          device_name = "NixOS-Spotify";
          bitrate = 160;
          volume_normalisation = true;
        };
      };
    };
  };
}
