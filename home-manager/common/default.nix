# home-manager/common/default.nix
{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
  ];

  home = {
    username = "jonash";
    homeDirectory = "/home/jonash";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  # Add your other common configurations here
}
