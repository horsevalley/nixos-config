{ config, pkgs, unstable, ... }:
{
  environment.systemPackages = [
    unstable.devpod
    unstable.direnv
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      devpod = unstable.devpod;
    })
  ];
}
