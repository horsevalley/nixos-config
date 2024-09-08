{ config, pkgs, ... }:

{

  imports = [
     ./hardware-configuration.nix
    ../common/default.nix

  ];

  networking.hostName = "legiony540-nixos";
  system.stateVersion = "24.05";

  services.logind.extraConfig = ''
    HandleLidSwitchExternalPower=ignore
  '';

}
