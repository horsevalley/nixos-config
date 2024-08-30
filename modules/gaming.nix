{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gamescope
    steam
    mangohud
    vkBasalt
    wine
    # Add other gaming-related packages here
  ];

  # Enable Vulkan for better performance in games
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [ vulkan-loader ];
  };

  # Enable Steam Runtime support
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Optional: Set specific environment variables for better game performance
  systemd.user = {
    services.gaming = {
      serviceConfig = {
        Environment = [
          "MANGOHUD=1"
          "VK_INSTANCE_LAYERS=VK_LAYER_MANGOHUD_overlay"
        ];
      };
    };
  };

  # Optional: Configure the kernel or other system settings for better gaming performance
  boot.kernelParams = [ "quiet" "splash" ];

  # USAGE
  # gamescope -w 1920 -h 1080 -- /path/to/your/game
}
