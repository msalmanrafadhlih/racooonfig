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

  outputs = { self, home-manager, ... }@inputs:
  let
    mkUser = { user ? "tquilla", system ? "x86_64-linux", module }: {
      ${user}   = home-manager.lib.homeManagerConfiguration {
        pkgs    = inputs.nixpkgs.legacyPackages.${system};
        modules = module; 
      };
    };

    mkModule = extraModules: {
      imports = [ ./modules ] ++ extraModules;
    };
  in
  {
    homeModules = {
      default  = mkModule [ ./users/bspwm ];
      niri     = mkModule [ ./users/niri ];
      hyprland = mkModule [ ./users/hyprland ];
    }; 

    # keep standalone homeConfigurations
    # for `home-manager switch --flake .#bspwm / #niri / #hyprland`
    homeConfigurations = {
      bspwm    = mkUser { module = [ self.homeModules.default ]; };
      niri     = mkUser { module = [ self.homeModules.niri ]; };
      hyprland = mkUser { module = [ self.homeModules.hyprland ]; };
    # i rarely use this homeConfigurations module, i use (sistem-)specialisations instead
    # so, this code is useless, u can delete it.
    # for me, i just want to keep it.
    };
  };
}
