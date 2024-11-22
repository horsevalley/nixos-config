{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = [
    (unstable.age.override {
    })
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      age = unstable.age; # Modern encryption tool with small explicit keys
    })
  ];
}

