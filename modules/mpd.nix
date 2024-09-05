{ config, lib, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/jonash/Music";  # Adjust this path
    user = lib.mkForce "mpd";
    group = "audio";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
      bind_to_address "127.0.0.1"
      port "6600"
    '';
  };

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    mpc_cli
    ncmpcpp
  ];

  # Configure MPD user and group
  users.users.mpd = {
    isSystemUser = true;
    group = "audio";
    extraGroups = [ "pipewire" ];
    description = "Music Player Daemon user";
    home = "/var/lib/mpd";
    createHome = true;
  };

  # Ensure the audio group exists
  users.groups.audio = {};

  # Enable PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Add your user to necessary groups
  users.users.jonash.extraGroups = [ "audio" "pipewire" ];

  # Ensure the MPD user has access to the PipeWire socket
  systemd.services.mpd.serviceConfig = {
    SupplementaryGroups = [ "pipewire" ];
  };

  # Open the firewall port for MPD
  networking.firewall.allowedTCPPorts = [ 6600 ];
}
