{
  inputs,
  lib,
  config,
  ...
}:

let
  home = config.home.homeDirectory;
  cursorTheme = "Skyrim-by-ru5tyshark-cursors";
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
      writeMode = "merge";
      pruneUnmanagedOverrides = false;

      settings = {
        global = {
          Context.filesystems = [
            "${home}/.icons:ro"
            "${home}/.local/share/icons:ro"
            "/usr/share/icons:ro"
          ];

          Context.sockets = [
            "x11"
            "wayland"
            "fallback-x11"
          ];

          Environment = {
            XCURSOR_THEME = cursorTheme;
            XCURSOR_SIZE = cursorSize;
            XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons:${home}/.icons:${home}/.local/share/icons";
            GTK_THEME = "Adwaita:dark";
          };
        };

        "com.spotify.Client" = {
          Environment = {
            XCURSOR_THEME = cursorTheme;
            XCURSOR_SIZE = cursorSize;
          };
        };
      };
    };
  };
}
