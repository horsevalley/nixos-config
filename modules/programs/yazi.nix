{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.yazi
    # file
    # imagemagick
    # kitty
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      yazi = unstable.yazi;
    })
  ];
}
