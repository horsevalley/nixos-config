{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = [
    (unstable.obsidian.override {
    })
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      obsidian = unstable.obsidian;
    })
  ];
}
