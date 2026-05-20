{ inputs, ... }: let
  lib = inputs.nixpkgs.lib;
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;
in forAllSystems (
  system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ (import ./overlays.nix { inherit inputs; }).default ];
    }
  )
  
