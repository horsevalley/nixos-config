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
  { device = "/dev/disk/by-uuid/14b78139-9c46-47f6-80a9-9cd5e25e5878";
    fsType = "ext4";
  };

  fileSystems."/boot" =
  { device = "/dev/disk/by-uuid/5E9A-70FE";
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
