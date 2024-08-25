# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # inputs.home-manager.nixosModules.home-manager
      ./modules/audio.nix
      ./modules/X11.nix
      ./modules/gnome.nix
      ./modules/programs/wayland/hyprland.nix
      ./modules/neovim.nix
      ./modules/fonts.nix
      ./modules/hardware/nvidia.nix
      ./modules/hardware/opengl.nix
      ./modules/hardware.nix
      ./modules/keyboard.nix
      ./modules/localization.nix
      ./modules/networking.nix
      ./modules/packages.nix
      ./modules/security.nix
      ./modules/services.nix
      ./modules/shell.nix
      ./modules/system.nix
      ./modules/users.nix
      ./modules/variables.nix
      ./modules/pcmanfm.nix
      ./modules/sddm.nix
    ];

  boot.extraModprobeConfig = ''
  options snd-hda-intel probe_mask=1
'';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
