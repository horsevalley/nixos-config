{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with unstable; [
    yazi
    ueberzug
    ffmpegthumbnailer
    poppler
    file
    git
  ];

  programs.yazi.enable = true;

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

  environment.shellInit = ''
    export PATH=$PATH:${unstable.yazi}/bin
    if [ -n "$BASH_VERSION" ]; then
      eval "$(yazi init bash)"
    elif [ -n "$ZSH_VERSION" ]; then
      eval "$(yazi init zsh)"
    fi
  '';

  # If you have a custom configuration file, you can add it like this:
  # environment.etc."yazi/yazi.toml".source = ./path/to/your/yazi.toml;
}
