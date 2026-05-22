{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  inp = inputs.racooonfig.inputs;
  st  = [ inp.st-nix.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  cfg = config.racooonfig;
in
{
  home.packages =
    lib.optionals (builtins.elem "st" cfg.listConfigurations) st;

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
