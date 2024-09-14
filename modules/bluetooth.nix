
{ config, pkgs, ... }:

{
  ##### Enable Bluetooth Service #####
  services.bluez = {
    enable = true;
    # Optional: Customize Bluetooth settings
    # deviceName = "MyNixOSDevice";
    # deviceClass = "0x00041C";
    # Enable experimental features if needed
    # experimental = true;
    # For auto-enable adapters
     autoEnable = true;
  };

  ##### Include Blueman in System Packages #####
  environment.systemPackages = with pkgs; [
    blueman
    # Include other packages if necessary
  ];

  ##### Firmware (Optional) #####
  # Include firmware if your Bluetooth adapter requires it
  hardware.firmware = [ pkgs.linux-firmware ];

}
