{ config, pkgs, ... }:

let
  unstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "0awagdjzv2fsy5v7a0wxz1hd642gsglib2gk4lnqm0iybly7kf0s";
  }) { 
    # Assuming you're on the same system architecture as your NixOS configuration
    system = pkgs.system;
  };
in {
  # Use Neovim from the unstable channel
  environment.systemPackages = with unstable; [
    neovim
  ];

  # Optionally, configure Neovim to be the default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  # You might want to add more Neovim specific configurations here, like plugins or custom settings
  # For example, if you use a plugin manager like vim-plug or packer.nvim, you would configure it here or in your Neovim init file.
}
