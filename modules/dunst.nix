{ config, lib, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "keyboard";
        width = 400;
        height = 700;
        offset = "0x19";
        padding = 20;
        horizontal_padding = 20;
        transparency = 45;
        font = "Monospace 16";
        format = "<b>%s</b>\n%b";
      };

      urgency_low = {
        background = "#1d2021";
        foreground = "#928374";
        timeout = 3;
      };

      urgency_normal = {
        background = "#458588";
        foreground = "#ebdbb2";
        timeout = 5;
      };

      urgency_critical = {
        background = "#1cc24d";
        foreground = "#ebdbb2";
        frame_color = "#fabd2f";
        timeout = 10;
      };
    };
  };

  # Ensure dunst is installed
  environment.systemPackages = [ pkgs.dunst ];

  # If you want to use a custom config file instead of the settings above,
  # you can uncomment and modify the following:
  # 
  # environment.etc."dunst/dunstrc".text = ''
  #   [global]
  #   monitor = 0
  #   follow = keyboard
  #   width = 400
  #   height = 700
  #   offset = 0x19
  #   padding = 20
  #   horizontal_padding = 20
  #   transparency = 45
  #   font = Monospace 16
  #   format = "<b>%s</b>\n%b"
  #   [urgency_low]
  #   background = "#1d2021"
  #   foreground = "#928374"
  #   timeout = 3
  #   [urgency_normal]
  #   foreground = "#ebdbb2"
  #   background = "#458588"
  #   timeout = 5
  #   [urgency_critical]
  #   background = "#1cc24d"
  #   foreground = "#ebdbb2"
  #   frame_color = "#fabd2f"
  #   timeout = 10
  # '';
  #
  # system.activationScripts = {
  #   dunstSetup = ''
  #     mkdir -p /home/jonash/.config/dunst
  #     ln -sf /etc/dunst/dunstrc /home/jonash/.config/dunst/dunstrc
  #     chown -R jonash:users /home/jonash/.config/dunst
  #   '';
  # };
}
