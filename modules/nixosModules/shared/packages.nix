{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  inp = inputs.racooonfig.inputs;
  cfg = config.racooonfig;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inp.matugen.packages.${system}.default

      # High-performance Lua implementation
      luajit 

      (python3.withPackages (
        ps: with ps; [
          pywal
          haishoku
        ]
      ))
    ];
  };
}
