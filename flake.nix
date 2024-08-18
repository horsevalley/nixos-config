{
  description = "My modular x11 gnome config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # you can add the stable channel here if u dont want unstable

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in 
  {

    nixosConfigurations = {
    nixos-config = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system; };

      modules = [
      ./nixos/configuration.nix
      ];
    };
   };

   };
  }
