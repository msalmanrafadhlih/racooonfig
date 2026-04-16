{ mkSymlink, ... }:
let
  configs = {
		"matugen/templates"   = "templates";
		"matugen/websites"    = "websites";
		"matugen/config.toml" = "config.toml";
  };

in
{
  # Symlink path to ~./config/*
  xdg.configFile = mkSymlink {
    target = "matugen";
  } configs;
}
