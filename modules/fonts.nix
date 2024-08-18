{ config, pkgs, ... }:

{
  # Nerdfonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
  };
}
