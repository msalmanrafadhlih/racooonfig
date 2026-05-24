{
  pkgs,
  mkSymlink,
  lib,
  config,
  ...
}:
let
  configs = {
    ".gemini/settings.json" = "./settings.json";
  };
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "gemini" cfg.listConfigurations) {
    home.file = mkSymlink {
      target = "gemini";
    } configs;

    home.packages = with pkgs; [
      gemini-cli
    ];
  };
}
