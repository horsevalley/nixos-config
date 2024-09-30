{ config, pkgs, ... }:

{

  imports = [
     ./hardware-configuration.nix
    ../common/default.nix
    ./graphics.nix

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
    HandleLidSwitch=suspend
  '';

  # Udev service
  services.udev = {
    # Allows member of the "video" group to change system backlight
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video %S%p/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w %S%p/brightness"
    '';
    path = [ pkgs.coreutils ]; # For chgrp
  };

  system.stateVersion = "24.05";

}
