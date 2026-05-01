# exported to ../flake.nix
{
	imports = [
	  ./opencam.nix
	  ./github-repos.nix
	  ./media.nix
	  ./run.nix
	  ./volume.nix
	  ./xyz.nix
	  ./tar.nix
	  ./brightness.nix
	  ./colorscript.nix

	  ./cli/01chat.nix
	  ./cli/battery.nix
	  ./cli/bookmarks.nix
	  ./cli/pandoc.nix
	  ./cli/img-compress.nix
	  ./cli/set-gtk-theme.nix
	  ./cli/get-github-hash.nix
	  ./cli/image-editor.nix
  ];
}
