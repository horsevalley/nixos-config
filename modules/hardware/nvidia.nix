{ config, pkgs, ... }:

{
  # Enable NVIDIA Drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  # NVIDIA
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    # Experimental. can cause sleep/suspend to fail.
    # Enable if you have graphical corruption issues or app crashes after waking from sleep.
    # Thix fixes it by saving entire VRAM memory to /tmp/ instead.
    powerManagement.enable = false;
    # Turns off GPU when not in use. Experimental. Only works on modern NVIDIA GPUs (Turing and newer).
    powerManagement.finegrained = false;
  };

    # STEAM
  # hardware.steam-hardware.enable = true;

  # OTHER GAME SETTINGS
  # programs.gamemode.enable = true;

}
