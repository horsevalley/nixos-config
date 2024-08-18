{
  description = "My modular x11 gnome config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # you can also add the nixos stable channel here if u dont want unstable
  };

  outputs = { self, nixpkgs }: 
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
      specialArgs = { inherit system; };

      modules = [
      ./nixos/configuration.nix
      ];
    };
   };

   };
  }
