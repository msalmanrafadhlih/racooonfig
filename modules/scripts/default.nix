# exported to ../flake.nix
{
	imports = [
	  ./01chat.nix
	  ./opencam.nix
	  ./battery.nix
	  ./bookmarks.nix
	  ./github-repos.nix
	  ./pandoc.nix
	  ./media.nix
	  ./run.nix
	  ./volume.nix
	  ./xyz.nix
	  ./tar.nix
	  ./background.nix
	  ./img-compress.nix
	  ./brightness.nix
	  ./colorscript.nix
	  ./set-gtk-theme.nix
	  ./rice-selector.nix
	  ./show-polybar.nix
	  ./hide-polybar.nix
	  ./get-github-hash.nix
	  ./image-editor.nix
  ];
}
