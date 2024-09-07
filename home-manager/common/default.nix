{ config, pkgs, inputs, ... }:

{

  imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

  home.username = "jonash";
  home.homeDirectory = "/home/jonash";

  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.your-username = import ../../../home-manager/common;
  };

}
