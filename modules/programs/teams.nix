{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    google-chrome
    (writeShellScriptBin "launch-teams" ''
      #!${pkgs.bash}/bin/bash
      
      # Set basic environment variables
      export ELECTRON_FORCE_DEVICE_SCALE_FACTOR=1
      export CHROME_FORCE_DEVICE_SCALE_FACTOR=1
      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_DESKTOP=Hyprland
      export XDG_SESSION_TYPE=wayland
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export GDK_BACKEND=wayland

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
}
