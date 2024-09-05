{ config, pkgs, ... }:

{

  imports = [
     ./hardware-configuration.nix
     ../../modules/audio.nix
     ../../modules/X11.nix
     ../../modules/gnome.nix
     ../../modules/programs/wayland/hyprland.nix
     ../../modules/fonts.nix
     ../../modules/hardware/nvidia.nix
     ../../modules/hardware/opengl.nix
     ../../modules/keyboard.nix
     ../../modules/localization.nix
     ../../modules/networking.nix
     ../../modules/packages.nix
     ../../modules/security.nix
     ../../modules/services.nix
     ../../modules/shell.nix
     ../../modules/system.nix
     ../../modules/users.nix
     ../../modules/variables.nix
     ../../modules/pcmanfm.nix
     ../../modules/sddm.nix
     ../../modules/git.nix
     ../../modules/librewolf.nix
     ../../modules/gaming.nix

  ];

  networking.hostName = "legiony540-nixos";
  system.stateVersion = "24.05";

  systemd = {
  services.logind = {
    extraConfig = ''
      HandleLidSwitchExternalPower=ignore
    '';
  };
};


}
