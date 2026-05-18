# exported to ../flake.nix
{
	imports = [
	  ./pandoc.nix
	  ./volume.nix
	  ./01chat.nix
	  ./battery.nix
	  ./bookmarks.nix
	  ./brightness.nix
	  ./img-compress.nix
	  ./image-editor.nix
	  ./set-gtk-theme.nix
	  ./get-github-hash.nix
	  ./wallpaper-selection.nix
  ];
}
