# nixos/common.nix
{ config, pkgs, ... }:

{
  users.users.jonash = {
    isNormalUser = true;
    home = "/home/jonash";
    extraGroups = [ "wheel" ]; # Add other groups as needed
    description = "Jonas Hestdahl"; # This is where you can put your full name
  };

  # Other system-wide configurations...
}
