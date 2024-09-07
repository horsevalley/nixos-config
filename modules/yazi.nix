{ config, pkgs, ... }:

let
  unstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    # sha256 = "1vc8bzz04ni7l15a9yd1x7jn0bw2b6rszg1krp6bcxyj3910pwb7";
    sha256 = "0s6h7r9jin9sd8l85hdjwl3jsvzkddn3blggy78w4f21qa3chymz";
  # sha256 = "1dmng7f5rv4hgd0b61chqx589ra7jajsrzw21n8gp8makw5khvb2";

  }) { 
    system = pkgs.system;
  };
in {
  # Use Yazi from the unstable channel
  environment.systemPackages = with unstable; [
    yazi
    ueberzug
    ffmpegthumbnailer
    poppler
    file
  ];

  # Configure Yazi
  programs.yazi.enable = true;

  # Install Yazi plugins
  system.activationScripts = {
    installYaziPlugins = ''
      YAZI_PLUGIN_DIR="$HOME/.config/yazi/plugins"
      if [ ! -d "$YAZI_PLUGIN_DIR" ]; then
        mkdir -p "$YAZI_PLUGIN_DIR"
        if [ -d "/tmp/yazi" ]; then
          rm -rf /tmp/yazi
        fi
        ${unstable.git}/bin/git clone https://github.com/sxyazi/yazi.git /tmp/yazi
        if [ -d "/tmp/yazi/plugins" ]; then
          cp -r /tmp/yazi/plugins/* "$YAZI_PLUGIN_DIR/"
        fi
        rm -rf /tmp/yazi
      fi
    '';
  };

  # Add Yazi to PATH and set any necessary environment variables
  environment.shellInit = ''
    export PATH=$PATH:${unstable.yazi}/bin
  '';

  # If you have a custom configuration file, you can add it like this:
  # environment.etc."yazi/yazi.toml".source = ./path/to/your/yazi.toml;
}
