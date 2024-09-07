{ config, pkgs, ... }:



let
  unstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "1vc8bzz04ni7l15a9yd1x7jn0bw2b6rszg1krp6bcxyj3910pwb7";
    # sha256 = "0s6h7r9jin9sd8l85hdjwl3jsvzkddn3blggy78w4f21qa3chymz";
    # sha256 = "1dmng7f5rv4hgd0b61chqx589ra7jajsrzw21n8gp8makw5khvb2";
  }) { 
    # Assuming you're on the same system architecture as your NixOS configuration
     system = pkgs.system;
     };
in {
  # Use Neovim from the unstable channel
  environment.systemPackages = with unstable; [
    neovim
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

}
