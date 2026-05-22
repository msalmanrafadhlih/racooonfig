{ ... }: {
  imports = [
    ./mimeApps.nix
    ./flatpak.nix
    ./xsession.nix
    ./specialisation.nix
    ./gui-apps.nix
  ];
}
