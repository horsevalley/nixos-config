{ config, pkgs, ... }:
{
  imports = [
    ../common/default.nix
    ./hardware-configuration.nix
    ../../modules/gaming.nix
    ../../modules/hardware/nvidia.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "horsepowr-nixos";

  fileSystems."/mnt/IronWolf8TB" = {
    device = "/dev/disk/by-uuid/fb9f1b7b-955a-4f54-89bc-e0bd11e9cbf1";
    fsType = "ext4";
  };

  swapDevices = [
  { device = "/swapfile";
    size = 16*1024;
  }
];

  system.stateVersion = "24.05";
}
