{ inputs, ... }:
{
  packages       = inputs.racooon.packages; # custom packages built against nixpkgs
  mapAll         = inputs.racooon.mapAll;
  mapDir         = inputs.racooon.mapAll;
  mapFile        = inputs.racooon.mapAll;
}
