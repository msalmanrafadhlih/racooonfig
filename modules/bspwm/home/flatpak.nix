{ inputs, ... }:
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    
    # Jika hanya ingin menambah beta tanpa menghapus flathub bawaan:
    remotes = [
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];

    update.auto.enable = true;
    uninstallUnmanaged = true;

    packages = [
      "com.spotify.Client"
    ];
  };

}
