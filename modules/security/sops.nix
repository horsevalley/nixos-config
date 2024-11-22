{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = [
    (unstable.sops.override {
    })
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      sops = unstable.sops; # Simple and flexible tool for managing secrets
    })
  ];
}
