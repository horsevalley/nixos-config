{ config, pkgs, ... }:

{

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  boot.kernelParams = [ "i915.enable_fbc=1" "i915.enable_psr=2" ];

}

