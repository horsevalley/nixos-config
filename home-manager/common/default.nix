# home-manager/common/default.nix
{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
  ];

  home.username = "Jonas Hestdahl";
  home.homeDirectory = "/home/jonash";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # Add your other common configurations here
}
