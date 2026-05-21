{
  inputs,
  config,
  lib,
  ...
}:
let
  inp = inputs.racooonfig.inputs;
  cfg = config.racooonfig;
in
{
  imports = [ inp.xytz.homeManagerModules.default ];

  config = lib.mkIf (builtins.elem "xytz" cfg.listConfigurations) {

    programs.xytz = {
      enable = true;
    };
  };
}
