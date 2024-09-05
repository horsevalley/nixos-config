{ config, lib, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/jonash/Music";  # Adjust this path
    extraConfig = ''
      audio_output {
        type "pulse"
        name "PulseAudio"
      }
      bind_to_address "127.0.0.1"
      port "6600"
    '';
    # If you want MPD to run as your user instead of the mpd user
    user = "jonash";  # Replace with your username
  };

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    mpc_cli
    ncmpcpp
  ];

  # Allow your user to access MPD
  users.users.jonash.extraGroups = [ "audio" ];

  # Open the firewall port for MPD (if needed)
  networking.firewall.allowedTCPPorts = [ 6600 ];
}
