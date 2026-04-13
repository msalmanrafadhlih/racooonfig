{ dotfiles, config, ... }:
let
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  home = config.home.homeDirectory;
  dotfiles_path = "${home}/.dotfiles/${dotfiles}/configs/matugen";

  configs = {
		"matugen/templates" = "templates";
		"matugen/websites" = "websites";
		
		"matugen/config.toml" = "config.toml";
  };

in
{
  # Symlink path to ~./config/*
  xdg.configFile = builtins.mapAttrs (name: subpath: {source =
    create_symlink "${dotfiles_path}/${subpath}";
    recursive = true;
  }) configs;
}
