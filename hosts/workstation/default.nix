{ config, pkgs, ... }:
{
  imports = [ 
    ../common/default.nix
    ./hardware-configuration.nix
  ];

  # Networking
  networking.hostName = "horsepowr-nixos"; # Replace with your actual hostname
  networking.networkmanager.enable = true;

}
