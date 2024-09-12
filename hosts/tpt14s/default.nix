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
  { device = "/dev/disk/by-uuid/3c32c69c-20cf-4cc0-9730-d92839dc2c4a";
    fsType = "ext4";
  };

  fileSystems."/boot" =
  { device = "/dev/disk/by-uuid/9922-2A7F";
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
