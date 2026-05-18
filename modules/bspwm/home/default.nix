{ lib, pkgs, config, ... }:

let
  dotfiles = "bspwm";
  branch = "main";
  home = config.home.homeDirectory;
  dotfiles_path = "${home}/.dotfiles/${dotfiles}";
  repo_url = "https://github.com/msalmanrafadhlih/racooonfig.git";
  mkSymlink = import ../../mkSymlink.nix { inherit config dotfiles; };
in

{
  _module.args = { inherit mkSymlink dotfiles; };

  imports = [
    ./configs.nix
    ./mimeApps.nix
    ./xsession.nix
    ./flatpak.nix
  ];

  home.activation = {
   	setupDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
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
}
