{ inputs, ... }:
rec {
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
