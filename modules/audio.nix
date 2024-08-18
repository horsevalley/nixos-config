 # Enable sound.
   hardware.pulseaudio.enable = false;
   services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     jack.enable = true;
   };

   # MPD settings
  services.mpd = {
  enable = true;
  user = "jonash";
  musicDirectory = "/home/jonash/Music";
  network = {
    listenAddress = "any"; # This allows connections from other devices on your network
    port = 6600; # Use a different port
  };
  extraConfig = ''
  zeroconf_enabled "no"
    audio_output {
      type "pipewire"
      name "PipeWire Sound Server"
    }
    #audio_output {
     # type "pulse"
      #name "PulseAudio Sound Server"
    }
    #audio_output {
     # type "alsa"
      #name "ALSA Sound Server"
   # }
  '';
};
