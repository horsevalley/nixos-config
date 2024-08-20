
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland.enable = true;

  # Enable Wayland
  wayland.windowManager.hyprland = {
    enable = true;
  }

  # Optional, hint electron apps to use wayland:
   environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.hyprland.portalPackage
  programs.iio-hyprland.package
  programs.hyprland.systemd.setPath.enable = true;
  programs.hyprland.enable = true;
  programs.iio-hyprland.enable = true;
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  programs.hyprland.package = true;
  programs.hyprland.xwayland.enable = true;
  programs.hyprlock.enable = true;

}
