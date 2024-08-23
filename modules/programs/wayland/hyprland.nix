
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.setPath.enable = true;
  };

  # Hyprland specific packages
  environment.systemPackages = with pkgs; [
    hyprland
    kdePackages.polkit-kde-agent-1
    polkit_gnome
    waybar
    dunst
    grim
    slurp
    # ulauncher
    # rofi-wayland
    hyprpaper
    wl-clipboard
    # mako
    # swaynotificationcenter
    # swww # wallpaper daemon
    xdg-desktop-portal-hyprland
    nwg-look # GTK3 settings editor

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
  # programs.iio-hyprland.enable = true;

  # Enable Hypr idle
  services.hypridle.enable = true;

  # Optional, hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

}
