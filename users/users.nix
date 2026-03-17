{ username, lib, ... }:

{
  home.username = lib.mkDefault username;
  home.homeDirectory = "/home/${username}";
  programs.git.enable = true;

  specialisation.gamemode.configuration = {
    home.username = lib.mkForce "gamemode";
    home.homeDirectory = "/home/${username}";
    programs.git.enable = true;
  };
}
