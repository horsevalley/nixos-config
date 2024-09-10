{ config, pkgs, ... }:
{
  imports = [
    ../common/default.nix
    ./hardware-configuration.nix
  ];
  networking.hostName = "x99-5930k-nixos";
  # File systems. use systemdmount instead of fstab

  swapDevices = [
  { device = "/swapfile";
    size = 16*1024;
  }
];

  system.stateVersion = "24.05";
}
