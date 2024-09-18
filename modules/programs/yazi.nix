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

  # Remove the activation script that was causing Yazi to start automatically

  environment.shellInit = ''
    export PATH=$PATH:${unstable.yazi}/bin
  '';

  # Add shell integration through shell rc files
  environment.etc."bashrc.d/yazi-init.sh".text = ''
    eval "$(yazi init bash)"
  '';

  environment.etc."zshrc.d/yazi-init.zsh".text = ''
    eval "$(yazi init zsh)"
  '';

  # If you have a custom configuration file, you can add it like this:
  # environment.etc."yazi/yazi.toml".source = ./path/to/your/yazi.toml;
}
