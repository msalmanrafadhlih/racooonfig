# exported to ../flake.nix
{
	imports = [
	  ./opencam.nix
	  ./github-repos.nix
	  ./media.nix
	  ./run.nix
	  ./xyz.nix
	  ./tar.nix
	  ./get-wsize.nix
	  ./colorscript.nix

	  ./cli/pandoc.nix
	  ./cli/volume.nix
	  ./cli/01chat.nix
	  ./cli/battery.nix
	  ./cli/bookmarks.nix
	  ./cli/brightness.nix
	  ./cli/img-compress.nix
	  ./cli/image-editor.nix
	  ./cli/set-gtk-theme.nix
	  ./cli/get-github-hash.nix
	  ./cli/wallpaper-selection.nix
  ];
}
