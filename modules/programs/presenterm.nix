{ config, pkgs, unstable, ... }:
{
  environment.systemPackages = [
    unstable.presenterm # A terminal based slideshow tool
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      presenterm = unstable.presenterm;
    })
  ];
}
