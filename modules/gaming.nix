{ config, pkgs, ... }:

{
  # Steam settings
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
  programs.steam.proton = {
    enable = true;
    experimental = true;  # Use Proton Experimental for better compatibility with games
  };

  # Set Steam library path
  environment.variables.STEAM_LIBRARY_FOLDERS = "/mnt/IronWolf8TB/Games";

  # Install Lutris, Wine, and other gaming-related tools
  environment.systemPackages = with pkgs; [
    wine
    winetricks   # Useful for installing additional libraries needed by some Windows games
    lutris       # Game launcher for non-Steam games (like Battle.net)
    heroic-games-launcher # Heroic Games Launcher for Epic Games and GOG
    vkd3d        # DirectX 12 to Vulkan translation (for modern games)
    dxvk         # DirectX 9, 10, 11 to Vulkan translation (improves performance on Wine)
    vulkan-tools # Vulkan utilities for testing Vulkan capabilities
    vulkan-headers # Vulkan development headers (optional but useful)
  ];

  # Set Lutris and Heroic-specific game paths without overriding global variables
  environment.variables = {
    # Lutris-specific data directory
    LUTRIS_RUNTIME_DIR = "/mnt/IronWolf8TB/Games/lutris";

    # Wine prefix for Lutris/Battle.net games
    WINEPREFIX_BATTLENET = "/mnt/IronWolf8TB/Games/battlenet";

    # Heroic-specific games directory
    HEROIC_GAMES_FOLDER = "/mnt/IronWolf8TB/Games/heroic";
  };

  # NVIDIA driver setup
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;         # Use proprietary NVIDIA drivers
    nvidiaSettings = true;
    powerManagement.enable = false;     # Disable power management to avoid downclocking
    powerManagement.finegrained = false;
  };

  # Enable GameMode for gaming performance enhancements
  programs.gamemode.enable = true;

  # Ensure the games directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /mnt/IronWolf8TB/Games 0775 jonash users -"
  ];
}

