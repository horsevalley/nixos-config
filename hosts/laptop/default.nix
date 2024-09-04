{ config, pkgs, ... }:
{
  imports = [
    ../common/default.nix
    ./hardware-configuration.nix
  ];
  networking.hostName = "legiony540-nixos";
  system.stateVersion = "24.05";
}
