{ inputs, lib, ... }:
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
  };
}
