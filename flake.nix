{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";

    bspwm = {
      url = "github:msalmanrafadhlih/Dotfiles/bspwm";
      # url = "path:./bspwm"; # for testing
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri = {
    #   url = "github:msalmanrafadhlih/Dotfiles/niri";
    #   # url = "path:./niri"; # for testing
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # hyprland = {
    #   url = "github:msalmanrafadhlih/Dotfiles/hyprland";
    #   # url = "path:./hprland"; # for testing
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    ############################
    # - Set your System and Username here!!
    system    = "x86_64-linux";
    username  = "tquilla";

    flakePath = self.outPath;
    stable    = import inputs.stable { inherit system; config.allowUnfree = true; };
    mkHost = host: extraModules: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username flakePath system stable; hostname = host; };
      modules     = [ ./modules/configuration.nix ] ++ extraModules;
    };
  in
  {
    nixosConfigurations = { 
      bspwm    = mkHost "bspwm"    [ inputs.bspwm.nixosModules.default ];
      # niri     = mkHost "niri"     [ inputs.niri.nixosModules.default ];
      # hyprland = mkHost "hyprland" [ inputs.hyprland.nixosModules.default ];
    };
  };
}
