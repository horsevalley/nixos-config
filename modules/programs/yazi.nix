{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.yazi
    file
    imagemagick
    kitty
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      yazi = unstable.yazi;
      _7zz = prev._7zz.override {
        enableAsm = false;  # Disable assembly optimizations
      };
    })
  ];
}
