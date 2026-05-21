{
  description = "A declarative Users configuration built with intention.";

  outputs =
    { self, ... }@inputs:
    let
      # mapping nix files & directories
      myLibs = import ./.lib { inherit inputs self; };
    in
    {
      inherit (myLibs) packages mapAll mapDir mapFile;

      homeModules.racooonfig = {
        imports = [ ./modules/homeModules.nix ];
      };

      nixosModules.racooonfig = {
        imports = [ ./modules/nixosModules.nix ];
      };
    };

  inputs = {
    # /// package_managers /////////////////////////////////////////////
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    racooon = "github:msalmanrafadhlih/flexinix";

    ## ---- System Packages
    xytz = {
      url = "github:TQ-See/xytz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    st-nix = {
      url = "github:TQ-See/st-flexipatch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
}
