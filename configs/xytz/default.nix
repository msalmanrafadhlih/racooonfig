{ inputs, ... }:
let
  inp = inputs.racooonfig.inputs;
in
{
  imports = [ inp.xytz.homeManagerModules.default ];
  programs.xytz = {
    enable = true;
  };
}
