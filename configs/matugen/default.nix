{ mkSymlink, lib, config, ... }:
let
  cfg = config.racooonfig;
  configs = {
    "matugen/templates" = "templates";
    "matugen/websites" = "websites";
    "matugen/config.toml" = "config.toml";
  };
in
{
  config = lib.mkIf cfg.homeManager {
    # Symlink path to ~./config/*
    xdg.configFile = mkSymlink {
      target = "matugen";
    } configs;
  };
}
