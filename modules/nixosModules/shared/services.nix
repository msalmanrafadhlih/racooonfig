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
  imports = [ inp.nix-flatpak.nixosModules.nix-flatpak ];
  config = lib.mkIf cfg.enable {
    services = {
      pipewire.enable = true;
      # install flatpak binary
      # nix-snapd = true;
      flatpak = {
        enable = lib.mkDefault true;
        uninstallUnmanaged = lib.mkDefault true;
      };

    power-profiles-daemon.enable = true;
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
  };
}
