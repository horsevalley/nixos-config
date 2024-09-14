# modules/power-settings.nix
{ config, pkgs, lib, ... }:

let
  ##### Laptop-Specific Settings #####
  laptopSettings = {
    services.logind = {
      lidSwitch = lib.mkForce "suspend";
      lidSwitchDocked = lib.mkForce "ignore";
      handleLidSwitch = lib.mkForce "suspend";
      handleSuspendKey = lib.mkForce "suspend";
      # Uncomment if 'handleHibernateKey' exists
      # handleHibernateKey = lib.mkForce "hibernate";
      idleAction = lib.mkForce "suspend";
      idleActionDelaySec = 1800; # 30 minutes
    };

    services.tlp.enable = true;
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    services.acpid.enable = true;
  };

  ##### Desktop-Specific Settings #####
  desktopSettings = {
    services.logind = {
      lidSwitch = lib.mkForce "ignore";
      handleLidSwitch = lib.mkForce "ignore";
      handleSuspendKey = lib.mkForce "ignore";
      # Uncomment if 'handleHibernateKey' exists
      # handleHibernateKey = lib.mkForce "ignore";
      idleAction = lib.mkForce "ignore";
    };

    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  };
in
{
  ##### Define Custom Option #####
  options = {
    myConfig.isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set to true if the system is a laptop";
    };
  };

  ##### Conditionally Include Configurations #####
  # Merge laptop settings if 'myConfig.isLaptop' is true
  config = lib.mkIf config.myConfig.isLaptop laptopSettings

  # Merge desktop settings if 'myConfig.isLaptop' is false
    // lib.mkIf (!config.myConfig.isLaptop) desktopSettings;
}

