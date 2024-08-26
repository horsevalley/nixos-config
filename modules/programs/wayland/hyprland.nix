{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.setPath.enable = true;
    extraConfig = ''
    # Reserve space for top bar
    monitor=,addreserved,40,0,0,0
  '';
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
    wl-clipboard
    nwg-look # GTK3 settings editor
    wl-clipboard
    # waybar
    jq          # Not Wayland-specific, but needed for some Waybar modules
    grim        # For screenshots 
    slurp       # For area selection 
    rofi-wayland
    swww # Simple Wayland Wallpaper Watcher
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    swaylock
    swaylock-effects
    eww # ElKowar’s Wacky Widgets

    catppuccin-sddm

  ];
    
  # Enable XDG portal with Hyprland support
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  # Enable Hypr idle
  services.hypridle.enable = true;

  # Optional, hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    PATH = [
      "/run/current-system/sw/bin"
      "$HOME/.local/bin"
      "$PATH"
    ];
  };

}
