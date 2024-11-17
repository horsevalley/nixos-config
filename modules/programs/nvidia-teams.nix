{ config, pkgs, ... }:
{
  # Browser and Teams installation
  environment.systemPackages = with pkgs; [
    google-chrome
    chromium
  ];

  # NVIDIA specific configurations
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    # Enable ForceCompositionPipeline for better compatibility
    forceFullCompositionPipeline = true;
    # Package selection
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Environment variables for NVIDIA + Electron apps
  environment.sessionVariables = {
    # Force GPU acceleration
    CUDA_FORCE_PTX_JIT = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Electron/Chromium specific
    ELECTRON_FORCE_DEVICE_SCALE_FACTOR = "1";
    CHROME_FORCE_DEVICE_SCALE_FACTOR = "1";
    # Wayland specific
    GBM_BACKEND = "nvidia-drm";
    __GLX_GSYNC_ALLOWED = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    # Force X11 for better compatibility
    NIXOS_OZONE_WL = "0";
    XDG_SESSION_TYPE = "x11";
    ELECTRON_OZONE_PLATFORM_HINT = "x11";
  };

  # Enhanced OpenGL configuration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };
}
