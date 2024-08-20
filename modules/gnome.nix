
{ config, pkgs, ... }:

{
  # Enable X11
  services.xserver.enable = true;

  # Enable GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Disable Wayland
  services.xserver.displayManager.gdm.wayland = false;

  # Exclude GNOME packages that are Wayland-specific
  environment.gnome.excludePackages = with pkgs.gnome; [
    mutter
    gnome-shell
];

  # Force X11 for GNOME session
  services.displayManager.defaultSession = "gnome-xorg";

  # GNOME programs and utilities
  environment.systemPackages = with pkgs; [
    pkgs.gnome.gnome-terminal
    pkgs.gnome.gnome-tweaks
    pkgs.gnome.gnome-software
    pkgs.gnome.gnome-applets
    pkgs.gnome.gnome-common
    pkgs.gnome.gnome-session
    pkgs.gnome.gnome-session-ctl
    pkgs.gnome.gnome-keyring
    gnome-desktop
    gnome-extension-manager

  ];

}
