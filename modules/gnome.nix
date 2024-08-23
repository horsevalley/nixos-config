
{ config, pkgs, ... }:

{
  # Enable X11, gdm and GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = false;
    displayManager.gdm.wayland = false;
    desktopManager.gnome.enable = false;
    };

  services.displayManager.sddm = {
      enable = true;
      theme = "catppuccin";
  };

  # Set default session to hyprland
  services.displayManager.defaultSession = "hyprland";

  # GNOME programs and utilities
  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal
    gnome.gnome-tweaks
    gnome.gnome-software
    gnome.gnome-applets
    gnome.gnome-common
    gnome.gnome-session
    gnome.gnome-session-ctl
    gnome.gnome-keyring
    gnome-desktop
    gnome-extension-manager
    gnome.dconf-editor

  # Exclude GNOME packages that are Wayland-specific
  #environment.gnome.excludePackages = with pkgs.gnome; [
  #mutter
  #gnome-shell
  # ];


  ];

}
