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
  ];
}
