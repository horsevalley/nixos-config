{ config, pkgs, ... }:
{
  # General Security Settings

  # Enable PolicyKit, a toolkit for defining and handling authorizations
  # It's used for controlling system-wide privileges
  security.polkit.enable = true;

  # Enable RealtimeKit, which allows real-time scheduling of processes
  # This is often used by audio applications for low-latency audio processing
  security.rtkit.enable = true;

  # Configure SUID wrapper for slock (simple X display locker)
  # This allows slock to be run with elevated privileges
  security.wrappers.slock = {
    owner = "jonash";        # The owner of the slock binary
    group = "wheel";         # The group of the slock binary
    source = "${pkgs.slock}"; # The path to the slock binary
    capabilities = "cap_ipc_lock+ep"; # Gives slock the ability to lock memory
  };

  # Enable My TraceRoute (mtr), a network diagnostic tool
  # It combines the functionality of 'traceroute' and 'ping'
  programs.mtr.enable = true;

  # Note: GPG-related configurations have been moved to gpg.nix
  # This separation allows for better organization and easier management
  # of GPG-specific settings
}
