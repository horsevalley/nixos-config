# modules/power-settings.nix
{ config, pkgs, lib, ... }:

{
  # Common settings can go here if any
}

# Merge the laptop settings if the system is a laptop
// (lib.mkIf config.hardware.isLaptop {
  # Laptop-specific settings
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
})

# Merge the desktop settings if the system is not a laptop
// (lib.mkIf (!config.hardware.isLaptop) {
  # Desktop-specific settings
  services.logind = {
    lidSwitch = "ignore";
    handleLidSwitch = "ignore";
    handleSuspendKey = "ignore";
    handleHibernateKey = "ignore";
    idleAction = "ignore";
  };

  # CPU frequency scaling governor
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
})

