
{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = [
    (unstable.exodus.override {
    })
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      exodus = unstable.exodus;
    })
  ];
}
