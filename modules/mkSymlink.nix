{ config, dotfiles, ... }:
{ target ? "" }: configs:
let
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  home = config.home.homeDirectory;
  
  # Jika target kosong, suffix kosong. Jika ada, tambahkan slash.
  targetSuffix = if target == "" then "" else "/${target}";
  dotfiles_path = "${home}/.dotfiles/${dotfiles}/configs${targetSuffix}";
in
builtins.mapAttrs (name: subpath: {
  source = create_symlink "${dotfiles_path}/${subpath}";
  recursive = true;
}) configs
