{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.racooonfig;
  mapAll = inputs.racooonfig.mapAll;

  branch = "main";
  home = config.home.homeDirectory;
  dotfiles_path = "${home}/.dotfiles/racooonfig";
  repo_url = "https://github.com/msalmanrafadhlih/racooonfig.git";

  mkSymlink =
    {
      target ? "",
    }:
    configs:
    let
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
      # Jika target kosong, suffix kosong. Jika ada, tambahkan slash.
      targetSuffix = if target == "" then "" else "/${target}";
      path = "${dotfiles_path}/configs${targetSuffix}";
    in
    builtins.mapAttrs (name: subpath: {
      source = create_symlink "${path}/${subpath}";
      recursive = true;
    }) configs;

in

{

  imports = [ ./scripts ./bspwm ];

  config = lib.mkIf cfg.homeManager {
    _module.args = { inherit mkSymlink; };

    home.activation = {
      setupDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        		  # Buat folder .dotfiles jika belum ada
        		  mkdir -p ${dotfiles_path}

        		  if [ ! -d "${dotfiles_path}/.git" ]; then
        				echo "--- Cloning Dotfiles dari GitHub msalmanrafadhlih/racooonfig/${branch} ---"
        				${pkgs.git}/bin/git clone -b ${branch} --single-branch --depth 1 ${repo_url} "${dotfiles_path}"
        		  else
        				echo "--- Dotfiles sudah ada, melakukan check update (safe) ---"
        				cd "${dotfiles_path}"

        				# Melakukan fetch saja agar tidak merusak kerjaan lokal
                if ${pkgs.git}/bin/git ls-remote ${repo_url} &>/dev/null; then
                  ${pkgs.git}/bin/git fetch origin ${branch}
                else
                  echo "offline, skip"
                fi
        				echo "Gunakan 'git pull --rebase' secara manual di folder dotfiles jika ingin sinkronisasi."
        		  fi
        		'';
    };
  };
}
