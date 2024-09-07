
{ config, pkgs, ... }:

{
   # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = false;
   services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     jack.enable = true;
   };

  # Enable wireplumber
  services.pipewire.wireplumber = {
     enable = true;
  };
  
}
