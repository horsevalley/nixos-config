# hosts/common/default.nix
{ config, pkgs, ... }:

{
  users.users.jonash = {
    isNormalUser = true;
    home = "/home/jonash";
    extraGroups = [ "wheel" ]; # Add other groups as needed
  };

  # Other system-wide configurations...
}
