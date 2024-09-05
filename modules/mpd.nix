{ config, lib, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/jonash/Music";  # Adjust this path
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
      bind_to_address "127.0.0.1"
      port "6601"  # Changed from 6600 to 6601
    '';
    user = "jonash";  # Replace with your username
  };

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    mpc_cli
    ncmpcpp
  ];

  # Allow your user to access MPD and audio
  users.users.jonash.extraGroups = [ "audio" "pipewire" ];

  # Enable PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Ensure the MPD user has access to the PipeWire socket
  systemd.services.mpd.serviceConfig = {
    SupplementaryGroups = [ "pipewire" ];
  };

  # Open the firewall port for MPD
  networking.firewall.allowedTCPPorts = [ 6601 ];  # Changed from 6600 to 6601
}
