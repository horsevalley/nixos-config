{
  description = "NixOS multi-machine configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        "horsepowr-nixos" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/workstation
          ];
        };
        "legiony540-nixos" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/laptop
          ];
        };
      };
    };
}
