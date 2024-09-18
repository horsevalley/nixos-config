{ config, pkgs, ... }:

{

  time.timeZone = "Europe/Oslo"; # Set your time zone.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Experimental Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}
