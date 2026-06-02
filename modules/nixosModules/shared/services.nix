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
      udisks2.enable = lib.mkDefault true; # Storage Manager (USBmounting, external HDD/SSD)
      dbus.enable = lib.mkDefault true; # App to App Communications (Discord RPC, MountUSB in FileManager)
      pipewire.enable = true;
      # install flatpak binary
      # nix-snapd = true;
      flatpak = {
        enable = lib.mkDefault true;
        uninstallUnmanaged = lib.mkDefault true;
      };
    };
    programs.gdk-pixbuf.modulePackages = [
      pkgs.webp-pixbuf-loader
    ];
  };
}
