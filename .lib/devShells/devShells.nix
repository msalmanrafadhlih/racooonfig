
{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in
lib.genAttrs lib.systems.flakeExposed (
  system:
  let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ (import ./overlays.nix { inherit inputs; }).default ];
    };
  in
  {

    # Default
    default = inputs.devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        {
          devenv.root = builtins.toString ../../.;
          languages.nix.enable = true;
          packages = with pkgs; [
            devenv
            cargo
          ];
        }
      ];
    };
  }
)
