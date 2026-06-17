{ inputs, config, lib, pkgs, ... }:
let
  inp = inputs.racooonfig.inputs;
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "xytz" cfg.listConfigurations) {
    home.packages = [
      inputs.xytz.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
