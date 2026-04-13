{ inputs, ... }:

{
  _module.args.inputs = inputs.racooonfig.inputs;
  
  imports = [
    ../../configs/stylix
    ../../configs/matugen
  ];
}
