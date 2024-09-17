{
  description = "jonash NixOS multi-machine configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        "horsepowr-nixos" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit unstable; };
          modules = [
            ./hosts/horsepowr
          ];
        };
        "x99-5930k-nixos" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit unstable; };
          modules = [
            ./hosts/x99-5930k
          ];
        };
        "legiony540-nixos" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit unstable; };
          modules = [
            ./hosts/legiony540
          ];
        };
        "tpt14s-nixos" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit unstable; };
          modules = [
            ./hosts/tpt14s
          ];
        };
      };
    };
}
