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

  # Enable Plymouth as greeter
  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };

  # Enable the Syncthing service
  services.syncthing = {
    enable = true;
    user = "jonash";  # Replace with your actual username
    dataDir = "/mnt/IronWolf8TB/Syncthing";  # Adjust this path as needed
    #configDir = "/home/your_username/.config/syncthing";
    #overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    #overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    #devices = {
      # You can define your devices here if you want
      # "device-id" = {
      #   id = "device-id";
      #   name = "device-name";
      #   addresses = [ "tcp://ip:port" ];
      # };
    };
    #folders = {
      # You can define your sync folders here
      # "label" = {
      #   path = "/path/to/folder";
      #   devices = [ "device-id" ];
      # };
    #};
  #};

  # Enable hypridle and set options
  services.hypridle = {
    enable = true;
    listeners = [
      {
        timeout = 5;
        onTimeout = "${pkgs.libnotify}/bin/notify-send 'Idle' 'System will lock soon'";
      }
      {
        timeout = 10;
        onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
    lockCmd = "${pkgs.swaylock}/bin/swaylock";
  };
}
