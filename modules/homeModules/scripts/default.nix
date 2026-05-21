# exported to ../flake.nix
{ inputs, ... }:
let
  mapFile = inputs.racooonfig.mapFile;
in
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
