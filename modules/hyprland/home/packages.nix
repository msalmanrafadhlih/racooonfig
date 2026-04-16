{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    obs-studio.enable = true;  
  };
  
  home.packages = with pkgs; [
    vivaldi
  ];
}
