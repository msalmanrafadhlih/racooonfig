{ inputs, system, ... }:
let
  inp = inputs.racooonfig.inputs;
in
{
  environment.systemPackages = [    
    inp.matugen.packages.${system}.default
  ];
}
