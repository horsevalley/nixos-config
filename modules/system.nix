{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "horsepowr-nixos"; # Define your hostname.

  time.timeZone = "Europe/Oslo"; # Set your time zone.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Experimental Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # File systems. use systemdmount instead of fstab
  fileSystems."/mnt/IronWolf8TB" = {
  device = "/dev/disk/by-uuid/fb9f1b7b-955a-4f54-89bc-e0bd11e9cbf1";
  fsType = "ext4";

  system.stateVersion = "24.11";
};


}
