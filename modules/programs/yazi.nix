{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = [
    unstable.yazi
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      yazi = unstable.yazi;
    })
  ];

  # Ensure necessary dependencies are installed
  environment.systemPackages = with pkgs; [
    file
    imagemagick
    kitty
  ];
}
