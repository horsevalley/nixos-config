{ config, pkgs, ... }:
{
  # General Security Settings

  # Enable PolicyKit, a toolkit for defining and handling authorizations
  # It's used for controlling system-wide privileges
  security.polkit.enable = true;

  # Enable RealtimeKit, which allows real-time scheduling of processes
  # This is often used by audio applications for low-latency audio processing
  security.rtkit.enable = true;

}
