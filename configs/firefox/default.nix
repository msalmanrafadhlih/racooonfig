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
  import = [ ./firefox.nix ]; 
  config = lib.mkIf (cfg.homeManager && builtins.elem "firefox" cfg.listConfigurations) {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-bin;

      # --- POLICIES (Level Sistem/Global) ---
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # Opsional: biar bersih
      };

      # --- PROFILES ---
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        # EXTENSIONS
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
        ];

        # SETTINGS (about:config)
        # Semua preferensi dari file kedua pindah ke sini
        settings = {
          # --- GENERAL ---
          "browser.startup.homepage" = "about:blank";
          "browser.search.region" = "ID";
          "browser.search.isUS" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.disableResetPrompt" = true;
          "signon.rememberSignons" = false; # Pakai Bitwarden kan? Matikan ini.

          # --- PRIVACY (SAFE) ---
          "privacy.trackingprotection.enabled" = true;
          "privacy.donottrackheader.enabled" = true;

          # --- PRIVACY (CAUTION) ---
          # resistFingerprinting saya set FALSE agar jam tidak error (UTC) dan layout web aman.
          # Kalau kamu paranoid, set ke true.
          "privacy.resistFingerprinting" = false;
          "privacy.firstparty.isolate" = true; # Ini oke (mirip Total Cookie Protection)

          # --- TELEMETRY & BLOAT (MATIKAN SEMUA) ---
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "extensions.pocket.enabled" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # --- PERFORMANCE (LINUX SPECIFIC) ---
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.enabled" = true;
          "gfx.webrender.all" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Wajib buat Textfox/CSS
        };
      };
    };

    # # Pastikan kamu sudah import module textfox di home.nix atau flake.nix!
    # textfox = {
    #   enable = true;
    #   profile = "default"; # Harus match dengan nama profile di atas

    #   config = {
    #     tabs.horizontal.enable = false; # Vertical tabs ala TUI
    #     displayWindowControls = false;  # Matikan tombol close/min/max biar full keyboard driven? (Opsional)
    #     displayNavButtons = false;      # Minimalis ekstrem (Back/Forward pakai shortcut)
    #     displayUrlbarIcons = true;
    #     displaySidebarTools = true;
    #     displayTitles = true;

    #     # PERBAIKAN SINTAKS: Gunakan '' (dua tanda kutip tunggal) untuk multiline
    #     newtabLogo = ''
    # __       __  _                        _       _   _              _      _ _
    # \ \     / /__| | ___ ___  _ __ ___   ___  | |__  __ _  ___| | __ | | | | ___  _ __ ___ (_) ___| | |
    #  \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \ | '_ \ / _` |/ __| |/ / | |_| |/ _ \| '_ ` _ \| |/ _ \ | |
    #   \ V  V /  __/ | (_| (_) | | | | | |  __/ | |_) | (_| | (__|   <  |  _  | (_) | | | | | | |  __/_|_|
    #    \_/\_/ \___|_|\___\___/|_| |_| |_|\___| |_.__/ \__,_|\___|_|\_\ |_| |_|\___/|_| |_| |_|_|\___(_|_)
    #     '';

    #     font = {
    #       family = "JetBrainsMono Nerd Font";
    #       size = "14px";
    #     };
    #   };
    # };
  };
}
