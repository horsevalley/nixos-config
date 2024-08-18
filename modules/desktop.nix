
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
}
