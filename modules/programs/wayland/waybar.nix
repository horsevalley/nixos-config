{ config, pkgs, ... }:

{

  # Enable Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };


}
