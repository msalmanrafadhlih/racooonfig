{ inputs, ... }: let
  lib = inputs.nixpkgs.lib;
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;
in forAllSystems (
  system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [ (import ./overlays.nix { inherit inputs; }).default ];
      config = (import ./configs.nix { inherit inputs; }).default;
    }
  )
  
