{ config, pkgs, lib, ... }:
{
  # Install required packages
  environment.systemPackages = with pkgs; [
    google-chrome
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    (writeShellScriptBin "launch-teams" ''
      #!${pkgs.bash}/bin/bash
      
      # Set basic environment variables
      export ELECTRON_FORCE_DEVICE_SCALE_FACTOR=1
      export CHROME_FORCE_DEVICE_SCALE_FACTOR=1

      # Hyprland-specific portal configuration
      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_DESKTOP=Hyprland
      export XDG_SESSION_TYPE=wayland
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export GDK_BACKEND=wayland

      # Remove problematic GPU configs
      unset DISABLE_GPU
      unset GBM_BACKEND
      unset __GLX_VENDOR_LIBRARY_NAME
      unset CUDA_FORCE_PTX_JIT

      # Launch Chrome with Teams
      exec ${pkgs.google-chrome}/bin/google-chrome-stable \
        --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer \
        --ozone-platform=wayland \
        --enable-wayland-ime \
        --disable-gpu-memory-buffer-compositor-resources \
        --disable-accelerated-video-decode \
        --disable-accelerated-video-encode \
        --force-device-scale-factor=1 \
        --app=https://teams.microsoft.com
    '')
  ];

  # Enable XDG Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Enable dbus
  services.dbus = {
    enable = true;
    packages = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Add Teams Hyprland window rules
  wayland.windowManager.hyprland.extraConfig = ''
    windowrulev2 = workspace 3, class:^(chrome-teams)$
    windowrulev2 = float, class:^(chrome-teams)$
  '';
}
