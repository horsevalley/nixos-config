{ config, pkgs, ... }:

{
  # Enable neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}
