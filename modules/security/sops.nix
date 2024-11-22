
{ config, pkgs, lib, ... }:

{
  # Install necessary packages for GPG functionality
  environment.systemPackages = with pkgs; [
    sops # Simple and flexible tool for managing secrets
  ];

}
