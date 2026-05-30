{ mkSymlink, lib, config, ... }:
let
  cfg = config.racooonfig;
  configs = {
    "matugen/templates" = "templates";
    "matugen/config.toml" = "config.toml";
    "matugen/bspwm.toml" = "bspwm.toml";
    "matugen/test.toml" = "test.toml";
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
