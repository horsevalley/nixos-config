{ config, pkgs, ... }:
{
  # Common configurations
  home.username = "Jonas Hestdahl";
  home.homeDirectory = "/home/jonash";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # Add your common configurations here
}
