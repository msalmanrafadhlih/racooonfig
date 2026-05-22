# ./zen-browser
{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  inp = inputs.racooonfig.inputs;
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "zen-browser" cfg.listConfigurations) {
    programs.zen-browser = {
      enable = true;
      package = inp.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Profil default
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        # Settings (about:config)
        # Zen sudah punya banyak default bagus, kita hanya tweak sedikit.
        settings = {
          # --- UI & ESTETIKA (Minimalist) ---
          "zen.view.compact" = true; # Aktifkan Compact Mode (Hide Top Bar)
          "toolkit.tabbox.switchByScrolling" = true; # Ganti tab dengan scroll mouse di sidebar
          "browser.tabs.allow_transparent_browser" = true; # Efek transparan/blur (jika compositor support)

          # --- PRIVACY (Zen sudah hardened, jangan over-do) ---
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.fingerprintingProtection" = true; # Hati-hati, bisa bikin jam UTC (cek penjelasan sebelumnya)

          # --- PERFORMANCE ---
          "media.ffmpeg.vaapi.enabled" = true;
          "gfx.webrender.all" = true;

          # --- STARTUP ---
          "browser.startup.homepage" = "about:blank";
          "browser.sessionstore.resume_from_crash" = false;
        };
      };

      # Policies (Level Global)
      # Ini cara terbaik install ekstensi di Zen via Nix (karena NUR belum support Zen secara langsung)
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;

        # Auto-install Extensions (Cari ID-nya di URL Add-ons Mozilla)
        ExtensionSettings = {
          # uBlock Origin
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          # Dark Reader
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };
  };
}
