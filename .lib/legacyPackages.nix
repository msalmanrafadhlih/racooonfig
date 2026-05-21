{ inputs, ... }: let
  lib = inputs.nixos-stable.lib;
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;
in forAllSystems (
  system:
    import inputs.nixos-unstable {
      inherit system;
      overlays = [ (import ./overlays.nix { inherit inputs; }).default ];
      config = (import ./configs.nix { inherit inputs; }).default;
    }
  )
  
