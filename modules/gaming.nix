{ config, pkgs, ... }:

{
  # Enable Steam
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
  programs.steam.proton = {
    enable = true;
    experimental = true;  # Use Proton Experimental for better compatibility with games
  };

  # Enable Wine and Lutris
  environment.systemPackages = with pkgs; [
    wine
    winetricks   # Additional Wine tweaks
    lutris       # Game launcher for non-Steam games (like Battle.net)
  ];

  # NVIDIA drivers configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;         # Use proprietary NVIDIA drivers
    nvidiaSettings = true;
    powerManagement.enable = false;     # Disable power management to avoid downclocking
    powerManagement.finegrained = false;
  };

  # Enable Vulkan and DirectX-to-Vulkan translation (for games using DX9, DX10, DX11, DX12)
  environment.systemPackages = with pkgs; [
    vulkan-tools   # Vulkan testing tools
    vulkan-headers # Vulkan development headers
    vkd3d          # DirectX 12 to Vulkan translation
    dxvk           # DirectX 9, 10, 11 to Vulkan translation
  ];

  # Enable GameMode for gaming performance tweaks
  programs.gamemode.enable = true;

  # Optional: Other gaming-related tools (add more if necessary)
  environment.systemPackages = with pkgs; [
    # Any other gaming-related software like benchmarking tools
    # Example: glxinfo to check graphics information
    mesa-utils  # OpenGL utilities like glxinfo/glxgears for testing
  ];

  # Configure Optimus if on a laptop with hybrid graphics (optional)
  # hardware.nvidia.optimus.enable = true;
}
