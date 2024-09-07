{ config, lib, pkgs, ... }:

let
  username = "jonash"; # Replace with your username
in
{
  config = {
    services.mpd = {
      enable = true;
      user = "${username}";
      musicDirectory = "/home/${username}/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }
        
        audio_output {
          type   "fifo"
          name   "Visualizer feed"
          path   "/tmp/mpd.fifo"
          format "44100:16:2"
        }

        bind_to_address "127.0.0.1"
        port "6600"
        
        auto_update "yes"
        restore_paused "yes"
      '';
    };

    # Ensure the MPD state file directory exists and has correct permissions
    system.activationScripts.mpd-state-file = ''
      mkdir -p /var/lib/mpd/state
      chown -R ${username}:users /var/lib/mpd
    '';

    # Install mpc for command-line control of MPD
    environment.systemPackages = [ pkgs.mpc_cli ];

    # Enable PipeWire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Ensure PipeWire is started for the user's session
    systemd.user.services.pipewire.wantedBy = [ "default.target" ];
  };
}
