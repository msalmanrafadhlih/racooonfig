{ config, dotfiles_path, ... }:
{ target ? "", }: configs:
let
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  # Jika target kosong, suffix kosong. Jika ada, tambahkan slash.
  targetSuffix = if target == "" then "" else "/${target}";
  path = "${dotfiles_path}/configs${targetSuffix}";
in
builtins.mapAttrs (name: subpath: {
  source = create_symlink "${path}/${subpath}";
  recursive = true;
}) configs
