# ./default.nix
{ pkgs, ... }: 

let
  # Definisikan paket individual agar bisa dipanggil secara mandiri
  desktopify-lite = pkgs.callPackage ./desktopify-lite.nix {};
  rip             = pkgs.callPackage ./process-manager.nix {};

  # overlay-packages
  bloodrage-plymouth = pkgs.callPackage ./bloodrage-plymouth.nix {};
  qylock-sddm-theme  = pkgs.callPackage ./qylock-sddm-theme.nix {};
  my-grub-theme      = pkgs.callPackage ./my-grub-theme.nix {};
  cursor-memes       = pkgs.callPackage ./cursor-theme.nix {};
in
{
  # Ekspos paket individual (for spesifik packages ex. 'nix build .#desktopify-lite')
  inherit
    bloodrage-plymouth
    qylock-sddm-theme
    my-grub-theme
    cursor-memes
    desktopify-lite
    rip
    ;

  all = pkgs.symlinkJoin {
    name = "my-packages-collection";
    paths = [
      desktopify-lite
      rip
      # add new custom packages (independent)
    ];
  };
}
