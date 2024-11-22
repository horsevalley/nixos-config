
{ config, pkgs, lib, ... }:

{
  # Install necessary packages for GPG functionality
  environment.systemPackages = with pkgs; [
    age # Modern encryption tool with small explicit keys
  ];

}
