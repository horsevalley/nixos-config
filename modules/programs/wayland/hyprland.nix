{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.setPath.enable = true;
  };

  # Set SDDM as display manager
   services.displayManager.sddm = {
      enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
  };

  # Set default session to hyprland
  services.displayManager.defaultSession = "hyprland";

  # Hyprland specific packages
  environment.systemPackages = with pkgs; [
    hyprland
    kdePackages.polkit-kde-agent-1
    hyprpaper
    hyprlock
    wl-clipboard
    nwg-look # GTK3 settings editor
    wl-clipboard
    waybar
    jq          # Not Wayland-specific, but needed for some Waybar modules
    grim        # For screenshots 
    slurp       # For area selection 
    rofi-wayland
    swww # Simple Wayland Wallpaper Watcher
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr

    catppuccin-sddm
    pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    font  = "Noto Sans";
    fontSize = "16";
    clockEnabled = true;
    background = "${./backgrounds/Mountain_dark.png}";
    loginBackground = true;
    CustomBackground = true;
  }
  ];
    
  # Enable XDG portal with Hyprland support
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
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
