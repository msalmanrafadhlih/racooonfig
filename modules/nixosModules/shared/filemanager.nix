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
        environment.systemPackages = with pkgs; [
          kdePackages.dolphin
          kdePackages.dolphin-plugins
        ];
      })

      (lib.mkIf (cfg.fileManager == "thunar") {
        ###################################
        ## THUNAR OPTIMALIZATION
        #####################################
        services.tumbler.enable = lib.mkDefault true; # enable thumbnail in thunar
        services.gvfs.enable = lib.mkDefault true; # Thunar integration with plugins

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
