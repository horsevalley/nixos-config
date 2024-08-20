
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland.enable = true;

  # Enable Wayland
  wayland.windowManager.hyprland = {
    enable = true;
  }

  {
  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  }

  programs.hyprland.portalPackage
  programs.iio-hyprland.package
  programs.hyprland.systemd.setPath.enable;
  programs.iio-hyprland.enable = true;
  services.hypridle.enable = true;
  programs.hyprland.package = true;
  programs.hyprland.xwayland.enable = true;
  programs.hyprlock.enable = true;


  {
  # Some env variables from the NixOS docs
  env = LIBVA_DRIVER_NAME,nvidia
  env = XDG_SESSION_TYPE,wayland
  env = GBM_BACKEND,nvidia-drm
  env = __GLX_VENDOR_LIBRARY_NAME,nvidia
  }

  cursor {
      no_hardware_cursors = true;
  }

}
