{ username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  programs.git.enable = true;

  imports = [
    ./scripts

    ./gui-apps.nix
    ./specialisation.nix
  ];
}
