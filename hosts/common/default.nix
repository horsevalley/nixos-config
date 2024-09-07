# nixos/common.nix
{ config, pkgs, ... }:

{

  imports =
    [ 
      ./hardware-configuration.nix
      # Add other module imports here
    ];

  users.users.jonash = {
    isNormalUser = true;
    home = "/home/jonash";
    extraGroups = [ "wheel" ]; # Add other groups as needed
    description = "Jonas Hestdahl"; # This is where you can put your full name
  };

  # Other system-wide configurations...
  system.stateVersion = "24.05"; # Replace with your actual NixOS version if different

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

}
