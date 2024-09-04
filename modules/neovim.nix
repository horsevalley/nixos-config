{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    # Optional: Specify a hash and update it less frequently
    # sha256 = "0000000000000000000000000000000000000000000000000000";
  };
  
  # This allows you to override the unstable version if needed
  unstable = import (unstableTarball) {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  # Use Neovim from the unstable channel
  environment.systemPackages = with unstable; [
    neovim
  ];

  # Configure Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    # Add any additional Neovim configurations here
  };


}
