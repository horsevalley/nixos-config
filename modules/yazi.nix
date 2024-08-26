{ config, pkgs, ... }:

let
  unstable = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "1vc8bzz04ni7l15a9yd1x7jn0bw2b6rszg1krp6bcxyj3910pwb7";
  }) { 
    # Assuming you're on the same system architecture as your NixOS configuration
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
  programs.yazi = {
    enable = true;
    # Note: Yazi doesn't have built-in shell integration options in NixOS
  };

  # You might want to add more Yazi specific configurations here, like plugins or custom settings
  # For example, you can set up your custom configuration file or install plugins
  system.activationScripts = {
    installYaziPlugins = ''
      YAZI_PLUGIN_DIR="$HOME/.config/yazi/plugins"
      if [ ! -d "$YAZI_PLUGIN_DIR" ]; then
        mkdir -p "$YAZI_PLUGIN_DIR"
        ${unstable.git}/bin/git clone https://github.com/sxyazi/yazi.git /tmp/yazi
        cp -r /tmp/yazi/plugins/* "$YAZI_PLUGIN_DIR/"
        rm -rf /tmp/yazi
      fi
    '';
  };

  # If you want to add shell integration manually, you can do it like this:
  programs.bash.initExtra = ''
    if command -v yazi &> /dev/null; then
      eval "$(yazi --init-shell bash)"
    fi
  '';

  programs.zsh.initExtra = ''
    if command -v yazi &> /dev/null; then
      eval "$(yazi --init-shell zsh)"
    fi
  '';

  # If you have a custom configuration file, you can add it like this:
  # environment.etc."yazi/yazi.toml".source = ./path/to/your/yazi.toml;
}
