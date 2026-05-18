{
  description = "A declarative Users configuration built with intention.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## ---- System Packages
    xytz = {
      url = "github:TQ-See/xytz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    st-nix = {
      url = "github:TQ-See/st-flexipatch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # stylix = {
    #   url = "github:nix-community/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    plank-reloaded = {
      url = "github:zquestz/plank-reloaded";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:/InioX/Matugen";
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
    mkHome = hostname: { user ? "tquilla", system ? "x86_64-linux", module }: 
      home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit hostname system; username = user;  };
        pkgs    = inputs.nixpkgs.legacyPackages.${system};
        modules = module; 
      };

    mkModule = extraModules: {
      imports = [ ./modules  ] ++ extraModules;
    };
  in
  {
    homeModules = {
      default  = mkModule [ ./modules/bspwm/home ];
      niri     = mkModule [ ./modules/niri/home ];
      hyprland = mkModule [ ./modules/hyprland/home ];
    };

    # ✅ nixos module yang benar
    nixosModules = {
      bspwm-core = {
        imports = [
          ./modules/bspwm/systems
          ./modules/scripts/cli
        ];
      };
    };

    # keep standalone homeConfigurations
    # for `home-manager switch --flake .#bspwm / #niri / #hyprland`
    homeConfigurations = {
      bspwm    = mkHome { module = [ self.homeModules.default ]; };
      niri     = mkHome { module = [ self.homeModules.niri ]; };
      hyprland = mkHome { module = [ self.homeModules.hyprland ]; };
    # i rarely use this homeConfigurations module, i use (sistem-)specialisations instead
    # so, this code is useless, u can delete it.
    # for me, i just want to keep it.
    };
  };
}
