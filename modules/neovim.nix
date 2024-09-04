{ config, pkgs, ... }:
let
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    # Instead of specifying the hash here, we'll let Nix handle it
  }) { 
    system = pkgs.system;
  };
in {
  environment.systemPackages = with unstable; [
    neovim
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  # Other Neovim configurations...
}
