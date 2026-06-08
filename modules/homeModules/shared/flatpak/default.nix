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
  cfg = config.racooonfig;
in
{
  imports = [ inp.nix-flatpak.homeManagerModules.nix-flatpak ];

  config = lib.mkIf (cfg.homeManager && cfg.flatpak) {
    services.flatpak = {
      remotes = lib.mkOptionDefault [
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];

      update.auto.enable = lib.mkDefault true;
      uninstallUnmanaged = lib.mkDefault true;

      packages = import ./packages.nix { inherit lib config; }; 

      overrides = {
        writeMode = lib.mkDefault "merge";
        pruneUnmanagedOverrides = lib.mkDefault false;

        settings = {
          global = {
            Context.filesystems = lib.mkOptionDefault [
              "/nix/store:ro"
              "${home}/.local/share/flatpak/exports/share/icons:ro"
              "${home}/.local/share/flatpak/exports/share/themes:ro"
              "${home}/.themes:ro"
              "xdg-config/gtk-3.0:ro"
              "xdg-config/gtk-4.0:ro"
            ];

            Context.sockets = lib.mkOptionDefault [
              "x11"
              "wayland"
              "fallback-x11"
            ];

            # Environment = {
            #   XCURSOR_THEME = cursorTheme;
            #   XCURSOR_SIZE = cursorSize;
            #   XCURSOR_PATH = "${pkgs.cursor-memes}/share/icons";
            # };
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
  };
}
