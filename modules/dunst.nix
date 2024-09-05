{ config, lib, pkgs, ... }:

let
  dunstConfig = pkgs.writeText "dunstrc" ''
    [global]
    monitor = 0
    follow = keyboard
    width = 400
    height = 700
    offset = 0x19
    padding = 20
    horizontal_padding = 20
    transparency = 45
    font = Monospace 16
    format = "<b>%s</b>\n%b"

    [urgency_low]
    background = "#1d2021"
    foreground = "#928374"
    timeout = 3

    [urgency_normal]
    foreground = "#ebdbb2"
    background = "#458588"
    timeout = 5

    [urgency_critical]
    background = "#1cc24d"
    foreground = "#ebdbb2"
    frame_color = "#fabd2f"
    timeout = 10
  '';
in
{
  # Ensure dunst is installed
  environment.systemPackages = [ pkgs.dunst ];

  # Place the configuration file in /etc
  environment.etc."dunst/dunstrc".source = dunstConfig;

  # Create a system service for Dunst
  systemd.user.services.dunst = {
    description = "Dunst notification daemon";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dunst}/bin/dunst -config /etc/dunst/dunstrc";
      Restart = "always";
      RestartSec = 2;
    };
  };

  # Ensure the configuration is linked to the user's home directory
  system.activationScripts = {
    dunstSetup = ''
      mkdir -p /home/jonash/.config/dunst
      ln -sf /etc/dunst/dunstrc /home/jonash/.config/dunst/dunstrc
      chown -R jonash:users /home/jonash/.config/dunst
    '';
  };
}
