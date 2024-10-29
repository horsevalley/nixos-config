{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = [
    (unstable.devpod.override {
    })
  ];

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      devpod = unstable.devpod;
    })
  ];
}
