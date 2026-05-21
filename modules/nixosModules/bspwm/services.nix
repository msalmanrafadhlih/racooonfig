{ inputs, pkgs, lib, ... }:
let
  inp = inputs.racooonfig.inputs;
in
{
  imports = [ inp.nix-flatpak.nixosModules.nix-flatpak ];
  security.pam.services.i3lock.enable = true;
  security.pam.services.i3lock = { };
  security.pam.services.i3lock.text = ''
    		auth include login
    	'';
  services = {
    # install flatpak binary
    # nix-snapd = true;
    flatpak = {
      enable = true;
      uninstallUnmanaged = true;
    };
    ###################################
    ## THUNAR OPTIMALIZATION
    #####################################
    tumbler.enable = lib.mkDefault true; # thumbnails di Thunar
    udisks2.enable = lib.mkDefault true; # Storage Manager (USBmounting, external HDD/SSD)
    dbus.enable = lib.mkDefault true; # App to App Communications (Discord RPC, MountUSB in FileManager)
    gvfs.enable = lib.mkDefault true; # Thunar integration with plugins
  };

  programs.gdk-pixbuf.modulePackages = [
    pkgs.webp-pixbuf-loader
  ];
}
