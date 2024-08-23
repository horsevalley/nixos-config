{ config, pkgs, ... }:

{
  # Enable CUPS to print documents
  services.printing.enable = true; 

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  # Disable waiting for online services before boot
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable tuigreet instead of default greeter 
#   services.greetd = {
#   enable = true;
#   settings = {
#     default_session = {
#       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
#       user = "greeter";
#     };
#   };
# };

  # Enable Plymouth as greeter
  boot.plymouth = {
    enable = true;
    theme = "catppuccin";
    themePackages = [
      (pkgs.plymouth-theme-catppuccin.override {
        flavor = "mocha"; # You can choose: latte, frappe, macchiato, mocha
        accent = "blue"; # Choose your preferred accent color
      })
    ];
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

}
