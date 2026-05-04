{ inputs, lib, config, ... }:
let
  home = config.home.homeDirectory;
  in
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    # Pastikan remote utama 'flathub' tetap ada
    remotes = lib.mkOptionDefault [
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];

    update.auto.enable = true;
    uninstallUnmanaged = true; # Ini akan menghapus Flatpak yang tidak ada di list 'packages'

    # Add here the flatpaks you want to install
    packages = [
      {
        appId = "com.spotify.Client";
        origin = "flathub";
      }
      #"com.obsproject.Studio"
      #"im.riot.Riot"
    ];

    overrides.settings = {
      global = {
        Context = {
          filesystems = [
            "${home}/.icons:ro"
            "${home}/.local/share/icons:ro"
            "/usr/share/icons:ro"
          ];
        };

        Environment = {
          XCURSOR_THEME = "Ellen-Joe"; # ganti sesuai punyamu
          XCURSOR_SIZE = "24"; # sesuaikan
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons:${home}/.icons:/home/${home}/.local/share/icons";
        };
      };

      "com.spotify.Client" = {
        Environment = {
          XCURSOR_THEME = "Ellen-Joe";
        };
      };
    };
  };
}
