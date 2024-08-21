{ config, pkgs, ... }:

{

  # OpenGL
  hardware.graphics = {
    enable = true;
    # enable32Bit = true;
    # graphics.extraPackages = with pkgs; [
      # vaapiVdpau # Video Acceleration API
    # ];
  }

}
