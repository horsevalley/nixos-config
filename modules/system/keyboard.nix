
{ config, pkgs, ... }:

{
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "nodeadkeys";
    options = "eurosign:e,caps:escape";
  };

  # Configure console keymap
  console.keyMap = "no";
}
