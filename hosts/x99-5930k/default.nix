{ config, pkgs, ... }:
{
  imports = [
    ../common/default.nix
    ./hardware-configuration.nix
  ];
  networking.hostName = "x99-5930k-nixos";

  swapDevices = [
  { device = "/swapfile";
    size = 16*1024;
  }
];

  # use GRUB bootloader instead of systemd
  boot.loader = {
  grub = {
    enable = true;
    device = "nodev";  # Use this for UEFI systems
    efiSupport = true;
    useOSProber = true;  # Optional: enables OS prober to find other operating systems
  };
  efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
};

  system.stateVersion = "24.05";
}
