{ config, pkgs, ... }:

{

  imports = [
     ./hardware-configuration.nix
    ../common/default.nix
    ../../modules/gaming.nix
    ../../modules/hardware/nvidia.nix

  ];

  networking.hostName = "legiony540-nixos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" =
  { device = "/dev/disk/by-uuid/b978580b-596e-42bb-9a3a-c96ef998fb94";
    fsType = "ext4";
  };

  fileSystems."/boot" =
  { device = "/dev/disk/by-uuid/C74B-95F0";
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
