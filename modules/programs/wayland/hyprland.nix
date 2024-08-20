
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    # package = true;
    xwayland.enable = true;
    # portalPackage.enable = true;
    systemd.setPath.enable = true;
  };

  # Hyprland specific packages
  environment.systemPackages = with pkgs; [
    hyprland
    waybar
    grim
    slurp
    ulauncher
    rofi-wayland
    # hyprpaper
    wl-clipboard
    # mako
    swaynotificationcenter
    swww # wallpaper daemon
  ];

  # Enable XDG portal with Hyprland support
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  # Enable hyprlock
  programs.hyprlock.enable = true;

  # Enable waybar
  programs.waybar.enable = true;

  # Enable iio-hyprland
  programs.iio-hyprland.enable = true;

  # Enable Hypr idle
  services.hypridle.enable = true;

  # Optional, hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
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
