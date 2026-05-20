
{ inputs, ... }:
let
  lib = inputs.nixos-stable.lib;
in
lib.genAttrs lib.systems.flakeExposed (
  system:
  let
    pkgs = import inputs.nixos-unstable {
      inherit system;
      config = (import ../nixpkgs { inherit inputs; }).config;
      overlays = [ (import ../overlays { inherit inputs; }).default ];
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

    # Flutter
    flutter = inputs.devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        { devenv.root = builtins.toString ../../.; }
        ./flutter.nix
      ];
    };

  }
)
