# exported to ../flake.nix
{ mapFile, ... }: 
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
  ]
  ++ mapFile ./cli [] {};
}
