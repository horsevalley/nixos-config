
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland.enable = true;

  # Enable Wayland
  wayland.windowManager.hyprland = {
    enable = true;
  }
}
