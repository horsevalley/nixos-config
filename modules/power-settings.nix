# modules/power-settings.nix
{ config, pkgs, lib, ... }:

let
  # Define settings for laptops
  laptopSettings = {
    # Power management settings for laptops
    services.logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      handleLidSwitch = "suspend";
      handleSuspendKey = "suspend";
      handleHibernateKey = "hibernate";
      idleAction = "suspend";
      idleActionDelaySec = 1800; # 30 minutes
    };

    # Enable TLP for advanced power management (optional)
    services.tlp.enable = true;

    # CPU frequency scaling governor
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

    # Enable ACPI event daemon
    services.acpid.enable = true;
  };

  # Define settings for desktops
  desktopSettings = {
    # Power management settings for desktops
    services.logind = {
      lidSwitch = "ignore";
      handleLidSwitch = "ignore";
      handleSuspendKey = "ignore";
      handleHibernateKey = "ignore";
      idleAction = "ignore";
    };

    # CPU frequency scaling governor
    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  };
in
# Merge the appropriate settings based on whether the system is a laptop
(if config.hardware.isLaptop then laptopSettings else desktopSettings)

