{ config, pkgs, ... }:

{
  ##### Enable Bluetooth Service #####
  hardware.bluetooth.enable = true;

  ##### Include Blueman in System Packages #####
  environment.systemPackages = with pkgs; [
    blueman
    # Include other packages if necessary
  ];

  ##### Firmware (Optional) #####
  # Include firmware if your Bluetooth adapter requires it
  hardware.firmware = [ pkgs.linux-firmware ];

}

