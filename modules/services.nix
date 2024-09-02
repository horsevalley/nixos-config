{ config, pkgs, ... }:

{
  # Enable CUPS to print documents
  services.printing.enable = true; 

  # Enable dbus
  services.dbus.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  # Disable waiting for online services before boot
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable the Syncthing service
  services.syncthing.settings.devices = {
    enable = true;
    user = "jonash";  # Replace with your actual username
    dataDir = "/mnt/IronWolf8TB/Syncthing";  # Adjust this path as needed
    #configDir = "/home/your_username/.config/syncthing";
    #overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    #overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    devices = {
      # You can define your devices here if you want
       "device-id" = {
         id = "QGRRFNK-KICED3C-NPZWBQ4-DSRWY4T-UIKOI2P-WN7Z3YJ-5UHZWYA-6ZESHQL";
         name = "Pixel 6a";
      #   addresses = [ "tcp://ip:port" ];
       };
    };
    #folders = {
      # You can define your sync folders here
      # "label" = {
      #   path = "/path/to/folder";
      #   devices = [ "device-id" ];
      # };
    #};
  };

}
