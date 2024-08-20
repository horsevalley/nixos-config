
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = true;
    xwayland.enable = true;
    hyprlock.enable = true;
    portalPackage.enable = true;
    systemd.setPath.enable = true;
    iio-hyprland.enable = true;
  };

  # Hyprland-specific packages
  environment.systemPackages = with pkgs; [
    hyprland
    iio-hyprland

  ];

  # Enable Hypr idle
  services.hypridle.enable = true;

  # Enable Wayland
  wayland.windowManager.hyprland = {
    enable = true;
  }

  {
  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  }

  # Some env variables from the NixOS nvidia docs
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # cursor:no_hardware_cursors

  # cursor {
  #   no_hardware_cursors = true;
  # };

}
