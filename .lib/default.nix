{ inputs, ... }@args:
let

  lib = inputs.nixpkgs.lib;
  systems = lib.systems.flakeExposed;
  # Bagian yang menangani outputs.packages
  mkSystemPackages =
    modulePath:
    lib.genAttrs systems (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ (import ./overlays.nix { inherit inputs; }).default ];
        };
      in
      import modulePath { inherit pkgs; }
    );

  mapping        = import ./map-lib.nix         args;
  overlays       = import ./overlays.nix        args;
  legacyPackages = import ./legacyPackages.nix  args;
  # devShells      = import ./devShells           args;
in
{
  inherit
    mapping
    overlays
    # devShells
    legacyPackages
    ;

  packages = mkSystemPackages ./packages ;
}
