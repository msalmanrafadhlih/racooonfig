{
  description = "A declarative Users configuration built with intention.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## ---- System Packages
    xytz = {
      url = "github:TQ-See/xytz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rip = {
      url = "github:TQ-See/process-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    st-nix = {
      url = "github:TQ-See/st-flexipatch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## ---- Home-Manager Packages
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };

    yazi-compress = {
      url = "github:KKV9/compress.yazi";
      flake = false;
    };
  };

  outputs = { home-manager, ... }@inputs:
  let
    dotfiles = "bspwm";
    mkUser = user: extraModules: home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs dotfiles; username = user; };
      modules = [ ./configs ./scripts ] ++ extraModules;
    };
  in
  {
    # a NixOS module that root flake can import in mkHost
    nixosModules.default = { hostname, system, ... }:
    {
      imports = [ home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs system hostname; };
        backupFileExtension = "backup";
      };
    };

    # keep standalone homeConfigurations
    # for `home-manager switch --flake .#dev / gamin / server / work`
    homeConfigurations = {
      dev     = mkUser "dev"    [ ./users/dev.nix ];
      mode    = mkUser "gaming" [ ./users/gaming.nix ];
      service = mkUser "server" [ ./users/server.nix ];
      default = mkUser "work"   [ ./users/work.nix ];
    };
  };
}
