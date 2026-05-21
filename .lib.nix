{ inputs, ... }:
{
  packages       = inputs.racooon.packages; # custom packages built against nixpkgs
  overlays       = inputs.nur.overlays.default;
  mapDir         = inputs.racooon.mapping.mapDir;
  mapAll         = inputs.racooon.mapping.mapAll;
  mapFile        = inputs.racooon.mapping.mapFile;
}
