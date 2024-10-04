{ config, pkgs, ... }:
{
  imports = [
    ../common/default.nix
    ./hardware-configuration.nix
    ./ckb-next.nix
    ../../modules/gaming/gaming.nix
    ../../modules/hardware/nvidia.nix
  ];

  networking.hostName = "x99-5930k-nixos";

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

    fileSystems."/" =
    { device = "/dev/disk/by-uuid/4208f3d1-29a3-4799-a296-57a323be4cb0";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EA9B-87F0";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/mnt/SamsungEvo8702TB" = {
    device = "/dev/disk/by-uuid/4b449511-0b39-42f9-bb49-d49773598c7d";
    fsType = "ext4";
  };

  fileSystems."/mnt/LacieRugged4TB" = {
    device = "/dev/disk/by-uuid/6142-F029";
    fsType = "exfat";
  };

  swapDevices = [
  { device = "/swapfile";
    size = 16*1024;
  }
];

  system.stateVersion = "24.05";
}
