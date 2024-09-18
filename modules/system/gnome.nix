
{ config, pkgs, ... }:

{
  # Enable X11, gdm and GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = false;
    displayManager.gdm.wayland = false;
    desktopManager.gnome.enable = false;
    };

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

  ];

}
