{ config, pkgs, ... }:
{
  # Common configurations
  home.username = "your-username";
  home.homeDirectory = "/home/your-username";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # Add your common configurations here
}
