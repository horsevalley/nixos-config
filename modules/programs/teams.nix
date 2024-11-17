{ config, pkgs, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    teams-for-linux
  ];

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      teams-for-linux = unstable.teams-for-linux;
    })
  ];
}
