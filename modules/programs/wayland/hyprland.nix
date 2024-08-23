
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
    waybar
        (waybar.overrideAttrs (oldAttrs: {
       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )

    dunst
    grim
    slurp
    hyprpaper
    wl-clipboard
    # xdg-desktop-portal-hyprland
    # xdg-desktop-portal-gtk
    nwg-look # GTK3 settings editor

  ];

  # Enable XDG portal with Hyprland support
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  # Enable hyprlock
  programs.hyprlock.enable = true;

  # Enable waybar
  programs.waybar.enable = true;

  # Enable iio-hyprland
  # programs.iio-hyprland.enable = true; # only works on unstable channel

  # Enable Hypr idle
  services.hypridle.enable = true;

  # Optional, hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

}
