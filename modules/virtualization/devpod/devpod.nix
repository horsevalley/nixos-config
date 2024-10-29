{ config, pkgs, unstable, ... }:

{

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      devpod = unstable.devpod;
    })
  ];
}
