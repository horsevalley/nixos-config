{ config, pkgs, ... }:

{

  # X11 packages and utilities
  environment.systemPackages = with pkgs; [
    xorg.xorgserver
    xorg.xinit
  ];
}
