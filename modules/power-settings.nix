# modules/power-settings.nix
{ config, lib, ... }:

{
  ##### Define Custom Option #####
  options.myConfig.isLaptop = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Set to true if the system is a laptop";
  };

  ##### Configuration #####
  config = {
    services.logind.extraConfig = if config.myConfig.isLaptop then ''
      HandleLidSwitch=suspend
      HandleLidSwitchDocked=ignore
      HandleLidSwitchExternalPower=ignore
      HandleSuspendKey=suspend
      HandleHibernateKey=hibernate
      IdleAction=suspend
      IdleActionSec=1800
    '' else ''
      HandleLidSwitch=ignore
      HandleLidSwitchExternalPower=ignore
      HandleSuspendKey=suspend
      HandleHibernateKey=ignore
      IdleAction=ignore
    '';

    powerManagement.cpuFreqGovernor = if config.myConfig.isLaptop then "powersave" else "performance";

    # Enable TLP for laptops
    services.tlp.enable = config.myConfig.isLaptop;

    # Remove or comment out the following line to avoid conflict
    # services.acpid.enable = config.myConfig.isLaptop;
  };
}

