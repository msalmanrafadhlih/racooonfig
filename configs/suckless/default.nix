{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  inp = inputs.racooonfig.inputs;
  cfg = config.racooonfig;
in
{
  config = lib.mkIf (cfg.homeManager && builtins.elem "st" cfg.listConfigurations) {
    home.packages = [
      inp.st-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  #  home.packages = with pkgs; [
  # (pkgs.st.overrideAttrs (_: {
  # 	src = inputs.st-src;
  # 	patches = [ ];
  # }))
  #    (pkgs.dmenu.overrideAttrs (_: {
  #        src = inputs.dmenu-src;
  #        patches = [ ];
  #    }))
  # slock
  # surf
  #  ];
}
