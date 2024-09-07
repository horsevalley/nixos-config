{ config, pkgs, ... }:

let
  unstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "0s6h7r9jin9sd8l85hdjwl3jsvzkddn3blggy78w4f21qa3chymz";
  }) { 
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

  # Add Neovim to PATH and set any necessary environment variables
  environment.shellInit = ''
    export PATH=$PATH:${unstable.neovim}/bin
  '';

}

