# nixosModules.nix
{ inputs, ... }: let
  mapFile = inputs.racooonfig.mapFile;
in
{
  imports = mapFile ./nixosOptions [] {};
}
