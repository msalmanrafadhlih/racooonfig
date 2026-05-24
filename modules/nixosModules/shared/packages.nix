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
    environment.systemPackages = [
      inp.matugen.packages.${system}.default
    ]

    ++ (with pkgs; [

      # ======== X UTILS
      (python3.withPackages (
        ps: with ps; [
          pywal
          haishoku
        ]
      ))

      # ======== GTK
      gtk2
      gtk3
      gtk4
      dconf
      dconf-editor
    ]);
  };
}
