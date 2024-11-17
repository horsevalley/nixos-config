{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    microsoft-edge
  ];

  # Environment variables to fix rendering issues
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Enable Wayland support
    OZONE_PLATFORM = "wayland";  # Force Wayland usage
    # Disable GPU acceleration and hardware rendering which can cause blank screens
    DISABLE_GPU = "1";
    EDGE_DISABLE_GPU = "1";
    # Force software rendering
    EDGE_USE_GL = "desktop";
    EDGE_DISABLE_GPU_COMPOSITING = "1";
  };

  # Optional: Add chromium flags that also affect Edge
  environment.variables = {
    CHROMIUM_FLAGS = "--disable-gpu-driver-bug-workarounds --ignore-gpu-blocklist --disable-gpu-compositing";
  };
}
