{ inputs, ... }@args:
let
  lib            = inputs.nixpkgs.lib;
  forAllSystem   = lib.genAttrs lib.systems.flakeExposed;

  configs        = import ./configs.nix        args;
  mapping        = import ./map-lib.nix        args;
  overlays       = import ./overlays.nix       args;
  legacyPackages = import ./legacyPackages.nix args;

  # Bagian yang menangani outputs.packages
  mkSystemPackages =
    modulePath:
    forAllSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config   = configs.default;
          overlays = [ overlays.default ];
        };
      in
      import modulePath { inherit pkgs; }
    );

in
{
  inherit
    mapping
    configs
    overlays
    legacyPackages
    ;

  packages = mkSystemPackages ./packages ;
}
