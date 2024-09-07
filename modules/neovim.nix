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
    ripgrep # Useful for searching in Neovim
    fd      # Optional, but handy for fuzzy finding in Neovim
  ];

  # Optionally, configure Neovim to be the default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  # Neovim Plugin Installation
  system.activationScripts = {
    installNeovimPlugins = ''
      NVIM_PLUGIN_DIR="$HOME/.local/share/nvim/site/pack/packer/start"
      if [ ! -d "$NVIM_PLUGIN_DIR" ]; then
        mkdir -p "$NVIM_PLUGIN_DIR"
        ${unstable.git}/bin/git clone --depth 1 https://github.com/wbthomason/packer.nvim \
          "$NVIM_PLUGIN_DIR/packer.nvim"
      fi
    '';
  };

  # Add Neovim to PATH and set any necessary environment variables
  environment.shellInit = ''
    export PATH=$PATH:${unstable.neovim}/bin
  '';

}

