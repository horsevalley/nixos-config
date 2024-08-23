{ config, pkgs, ... }:

{
  # Nerdfonts
  # fonts = {
  #   fontDir.enable = true;
  #   packages = with pkgs; [
  #     (nerdfonts.override { fonts = [ "Meslo" ]; })
  #   ];
  # };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

}
