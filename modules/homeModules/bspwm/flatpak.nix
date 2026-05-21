{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  inp = inputs.racooonfig.inputs;
  home = config.home.homeDirectory;
  cursorTheme = "Skyrim-by-ru5tyshark-cursors";
  cursorSize = "24";
in
{
  imports = [ inp.nix-flatpak.homeManagerModules.nix-flatpak ];

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
            "/nix/store:ro"
            "${home}/.local/share/flatpak/exports/share/icons:ro"
            "${home}/.local/share/flatpak/exports/share/themes:ro"
            "xdg-config/gtk-3.0:ro"
            "xdg-config/gtk-4.0:ro"
          ];

          Context.sockets = [
            "x11"
            "wayland"
            "fallback-x11"
          ];

          Environment = {
            XCURSOR_THEME = cursorTheme;
            XCURSOR_SIZE = cursorSize;
            XCURSOR_PATH = "${pkgs.cursor-memes}/share/icons";
            GTK_THEME = "dynamic";
          };
        };

        "com.visualstudio.code".Context = {
          filesystems = [
            "xdg-config/git:ro" # Expose user Git config
            "/run/current-system/sw/bin:ro" # Expose NixOS managed software
          ];
          sockets = [
            "gpg-agent" # Expose GPG agent
            "pcsc" # Expose smart cards (i.e. YubiKey)
          ];
        };
      };
    };
  };
}
