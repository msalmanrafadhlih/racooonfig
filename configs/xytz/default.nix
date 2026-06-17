{ inputs, config, lib, pkgs, ... }:
let
  inp = inputs.racooonfig.inputs;
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "xytz" cfg.listConfigurations) {
    home.packages = [
      inp.xytz.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
