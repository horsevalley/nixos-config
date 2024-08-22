
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
    kdePackages.polkit-qt-1
    waybar
    dunst
    wofi
    wofi-pass
    grim
    slurp
    # ulauncher
    # rofi-wayland
    hyprpaper
    wl-clipboard
    # mako
    # swaynotificationcenter
    # swww # wallpaper daemon
    unclutter # hides mouse when idle 
    mnemosyne # spaced repetiton software 
    xdg-desktop-portal-hyprland
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
