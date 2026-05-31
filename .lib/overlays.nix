
# NOTE: final and prev -------

# final: = Use it when referring to a package that may have been modified by another overlay
# (such as final.system or final.callPackage).

# prev:  = Use if you want to refer to the original package from nixpkgs before modification.

{ inputs, ... }:
rec {
  # ... This one brings our custom packages from the 'pkgs' directory
  local-packages = (
    final: prev:
    import ./packages {
      inherit inputs;
      pkgs = final;
    }
  );

  default = inputs.nixpkgs.lib.composeManyExtensions [
    local-packages

    inputs.nur.overlays.default
  ];
}
