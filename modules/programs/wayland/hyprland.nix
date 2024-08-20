
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = true;
    xwayland.enable = true;
    portalPackage.enable = true;
    systemd.setPath.enable = true;
  };

  # Enable hyprlock
  programs.hyprlock.enable = true;

  # Enable iio-hyprland
  programs.iio-hyprland.enable

  # Enable Hypr idle
  services.hypridle.enable = true;

  # Enable Wayland
  wayland.windowManager.hyprland = {
    enable = true;
  }

  {
  # Optional, hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  };

  # Environment variables for NVIDIA and Wayland
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
