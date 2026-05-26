{ lib, config, inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  inp = inputs.racooonfig.inputs;
  cfg = config.racooonfig;

  hypr-unstable = inp.hyprland.inputs.nixpkgs.legacyPackages.${system};
in

{
  config = lib.mkIf (cfg.enable && builtins.elem "hyprland" cfg.windowManager) {
    programs.hyprland = {
      enable = true;
    };

    hardware.graphics = {
      package = hypr-unstable.mesa;

      # 32-bit support (e.g for Steam)
      enable32Bit = lib.mkForce true;
      package32 = hypr-unstable.pkgsi686Linux.mesa;
    };

    services.pipewire.enable = true;

    nix.settings = {
      substituters         = lib.mkAfter [ "https://hyprland.cachix.org" ];
      trusted-substituters = lib.mkAfter [ "https://hyprland.cachix.org" ];
      trusted-public-keys  = lib.mkAfter [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}
