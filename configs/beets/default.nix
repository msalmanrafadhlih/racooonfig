{
  mkSymlink,
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.racooonfig;
  configs = {
    "beets/config.yaml" = "config";
  };
in

{
  config = lib.mkIf (cfg.homeManager && builtins.elem "beets" cfg.listConfigurations) {
    home.packages = with pkgs; [
      beets
      yt-dlp
      ffmpeg
    ];

    xdg.configFile = mkSymlink {
      target = "beets";
    } configs;
  };
}
