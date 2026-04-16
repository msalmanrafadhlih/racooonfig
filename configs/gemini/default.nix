{ pkgs, mkSymlink, ... }: let
  configs = {
    ".gemini/settings.json" = "./settings.json";
  };
in {

  home.file = mkSymlink {
    target = "gemini";
  } configs;

  home.packages = with pkgs; [
    gemini-cli
  ];
}
