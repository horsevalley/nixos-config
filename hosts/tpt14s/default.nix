{ config, pkgs, ... }:

{

  imports = [
     ./hardware-configuration.nix
    ../common/default.nix

  ];

  networking.hostName = "tpt14s-nixos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" =
  { device = "/dev/disk/by-uuid/1255a04c-0477-4419-a0bf-e235c542289f";
    fsType = "ext4";
  };

  fileSystems."/boot" =
  { device = "/dev/disk/by-uuid/F3B4-6389";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077"];
  };

    swapDevices = [
  { device = "/swapfile";
    size = 16*1024;
  }
];

  services.logind.extraConfig = ''
    HandleLidSwitchExternalPower=ignore
  '';

  system.stateVersion = "24.05";

}
