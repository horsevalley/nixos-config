{ config, lib, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/jonash/Music";  # Replace with your actual username
    playlistDirectory = "/home/jonash/.config/mpd/playlists";  # Replace with your actual username
    extraConfig = ''
      auto_update "yes"
      restore_paused "yes"
      max_output_buffer_size "16384"

      audio_output {
        type  "pipewire"
        name  "PipeWire Sound Server"
      }

      audio_output {
        type    "fifo"
        name    "Visualizer feed"
        path    "/tmp/mpd.fifo"
        format  "44100:16:2"
      }
    '';
    network = {
      listenAddress = "127.0.0.1";  # Bind to localhost
      port = 6600;  # Default MPD port
    };
  };

  # Ensure the MPD user has access to the PipeWire socket
  users.users.mpd.extraGroups = [ "audio" ];

  # Create the playlists directory
  system.activationScripts = {
    mpdPlaylistDir = ''
      mkdir -p /home/jonash/.config/mpd/playlists
      chown -R jonash:users /home/jonash/.config/mpd
    '';
  };
}
