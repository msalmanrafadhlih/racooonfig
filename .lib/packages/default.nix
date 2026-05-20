# ./default.nix
{ pkgs, ... }: 

let
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
    ;
}
