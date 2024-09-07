{ config, pkgs, ... }:

{
  imports = [ 
    ../common/default.nix 
    ./hardware-configuration.nix 
    ./nvidia.nix 
    ./opengl.nix 
  ];

  # Networking
  networking.hostName = "legiony540-nixos"; # Replace with your actual hostname
  networking.networkmanager.enable = true;
}
