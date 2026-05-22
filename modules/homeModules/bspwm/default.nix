{ ... }: {
  imports = [
    ./mimeApps.nix
    ./flatpak.nix
    ./packages.nix
    ./xsession.nix
    ./specialisation.nix
    ./gui-apps.nix
  ];
}
