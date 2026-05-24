{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.racooonfig;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf (cfg.fileManager == "dolphin") {
        programs = {
          dolphin = {
            enable = true;
          };
        };
      })

      (lib.mkIf (cfg.fileManager == "thunar") {
        programs = {
          thunar = {
            enable = lib.mkDefault true;
            plugins = with pkgs; [
              thunar-volman
              thunar-dropbox-plugin
              thunar-vcs-plugin
              thunar-media-tags-plugin
              thunar-shares-plugin
              thunar-archive-plugin
            ];
          };
        };
      })
    ]
  );
}
