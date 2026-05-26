{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.racooonfig;
in

{
  config = lib.mkIf (cfg.homeManager && builtins.elem "nix-search" cfg.listConfigurations) {
    home.packages = with pkgs; [
      (pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];
        text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      })
    ];
  };
}
