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

    niri = {
      url = "github:msalmanrafadhlih/Dotfiles/niri";
      # url = "path:./niri"; # for testing
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:msalmanrafadhlih/Dotfiles/hyprland";
      # url = "path:./hprland"; # for testing
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    ############################
    # - Set your System and username here!!
    system    = "x86_64-linux";
    username  = "tquilla";

    flakePath = self.outPath;
    stable    = import inputs.stable { inherit system; config.allowUnfree = true; };

    mkHost = host: extraModules: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username flakePath system stable; hostname = host; };
      modules     = [ ./modules/configuration.nix  ] ++ extraModules;
    };

    # Output untuk Standalone (command: home-manager switch)
    # mkConfig = user: extraModules: home-manager.lib.homeManagerConfiguration {
    #   inherit system;
    #   extraSpecialArgs = { inherit inputs username flakePath system stable hostname; };
    #   modules          = [  ];
    # };
  in
  {
    nixosConfigurations = { 
      bspwm    = mkHost "bspwm"    [ ./environments/bspwm.nix inputs.bspwm.nixosModules.default ];
      niri     = mkHost "niri"     [ ./environments/niri.nix inputs.niri.nixosModules.default ];
      hyprland = mkHost "hyprland" [ ./environments/hyprland.nix inputs.hyprland.nixosModules.default ];
    };

    # homeConfigurations = {
    #   standard = mkConfig "${username}" [ inputs.standard.nixosModules.default ];
    #   minimal  = mkConfig "${username}" [ inputs.minimal.nixosModules.default ];
    # };
  };
}
