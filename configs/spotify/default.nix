{
  pkgs,
  lib,
  config,
  ...
}:
let
  home = config.home.homeDirectory;
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "spotify-flatpak" cfg.listConfigurations) {
    home.packages = [ pkgs.spicetify-cli ];

    home.activation = {
      setupSpicetifyFlatpak = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        SPOTIFY_PATH="${home}/.local/share/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify"
        PREFS_PATH="${home}/.var/app/com.spotify.Client/config/spotify/prefs"
        SPICETIFY="${pkgs.spicetify-cli}/bin/spicetify"

        if [[ -f "${home}/.cache/.spicetify" ]]; then
          exit 0
        fi

        if [ -d "$SPOTIFY_PATH" ] && [ -f "$PREFS_PATH" ]; then
          chmod a+wr "$SPOTIFY_PATH" || true
          chmod a+wr -R "$SPOTIFY_PATH/Apps" || true

          $SPICETIFY config spotify_path "$SPOTIFY_PATH"
          $SPICETIFY config prefs_path "$PREFS_PATH"

          # $SPICETIFY backup apply || \
          # ($SPICETIFY restore backup apply) || true

          touch "${home}/.cache/.spicetify"
        fi
      '';
    };

    # services.spotifyd = {
    #   enable = true;
    #   package = pkgs.spotifyd;
    #   settings = {
    #     global = {
    #       username_cmd = "${pkgs.coreutils}/bin/cat %h/.config/spotify/username";
    #       password_cmd = "${pkgs.coreutils}/bin/cat %h/.config/spotify/credentials";
    #       backend = "alsa"; # atau "alsa" kalau kamu pakai ALSA saja
    #       use_mpris = true;
    #       device_name = "NixOS-Spotify";
    #       bitrate = 160;
    #       volume_normalisation = true;
    #     };
    #   };
    # };
  };
}
