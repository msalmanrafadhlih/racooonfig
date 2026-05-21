{
  pkgs,
  mkSymlink,
  lib,
  config,
  ...
}:

let
  configs = {
    "rmpc/themes" = "themes";
    "rmpc/utils" = "utils";
    "rmpc/config.ron" = "config.ron";
    "rmpc/inspect" = "inspect_log.sh";
    "rmpc/playcount" = "increment_play_count";
  };
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (builtins.elem "rmpc" cfg.listConfigurations) {

    programs.rmpc = {
      enable = true;
      package = pkgs.rmpc;
    };

    # Langsung targetkan ke subfolder rmpc
    xdg.configFile = mkSymlink {
      target = "rmpc";
    } configs;
  };

}
