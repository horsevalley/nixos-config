{ config, pkgs, ... }:

{

  imports = [
     ./hardware-configuration.nix
    ../common/default.nix

  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "legiony540-nixos";
  system.stateVersion = "24.05";

  services.logind.extraConfig = ''
    HandleLidSwitchExternalPower=ignore
  '';

}
