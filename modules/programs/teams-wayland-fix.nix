{ config, pkgs, lib, ... }:
{
  # Install both options for flexibility
  environment.systemPackages = with pkgs; [
    microsoft-edge
    google-chrome  # Chrome often has better Wayland support
  ];

  # System-wide Wayland and rendering configurations
  environment.sessionVariables = {
    # Wayland specific
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    
    # Force software rendering and disable problematic GPU features
    DISABLE_GPU = "1";
    DISABLE_GPU_SANDBOX = "1";
    
    # Chromium/Edge specific
    CHROME_DISABLE_GPU_SANDBOX = "1";
    CHROME_USE_GL = "desktop";
    
    # Additional fixes
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    GDK_BACKEND = "wayland,x11";
  };

  # Enable WebRTC pipewire support
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # If you're using xdg-desktop-portal for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}
