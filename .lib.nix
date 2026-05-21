{ inputs, ... }:
{
  packages       = inputs.racooon.packages; # custom packages built against nixpkgs
  mapFile        = inputs.racooon.mapFile;
  mapAll         = inputs.racooon.mapAll;
  mapDir         = inputs.racooon.mapDir;
  overlays       = [ inputs.nur.overlays.default ];
}
