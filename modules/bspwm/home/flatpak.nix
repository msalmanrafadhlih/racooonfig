{ inputs, lib, config, ... }:

let
  home = config.home.homeDirectory;
  cursorTheme = "Ellen-Joe";
  cursorSize = "24";
in
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    remotes = lib.mkOptionDefault [
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];

    update.auto.enable = true;
    uninstallUnmanaged = true;

    packages = [
      {
        appId = "com.spotify.Client";
        origin = "flathub";
      }
    ];

    overrides = {
      # 🔥 ini opsi penting juga (biar jelas behavior)
      writeMode = "merge"; # atau "replace"
      pruneUnmanagedOverrides = false;

      settings = {
        global = {
          # =====================
          # CONTEXT SECTION
          # =====================
          Context.filesystems = [
            "${home}/.icons:ro"
            "${home}/.local/share/icons:ro"
            "/usr/share/icons:ro"
          ];

          # optional tapi sering berguna
          Context.sockets = [
            "x11"
            "wayland"
            "fallback-x11"
          ];

          # =====================
          # ENVIRONMENT SECTION
          # =====================
          Environment.XCURSOR_THEME = cursorTheme;
          Environment.XCURSOR_SIZE  = cursorSize;

          Environment.XCURSOR_PATH =
            "/run/host/user-share/icons:/run/host/share/icons:${home}/.icons:${home}/.local/share/icons";

          # optional (kadang bantu theme consistency)
          Environment.GTK_THEME = "Adwaita:dark";
        };

        # =====================
        # APP-SPECIFIC OVERRIDE
        # =====================
        "com.spotify.Client" = {
          Environment.XCURSOR_THEME = cursorTheme;
          Environment.XCURSOR_SIZE  = cursorSize;
        };
      };
    };
  };
}
