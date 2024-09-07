{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    pass
  ];

  environment.variables = {
    PASSWORD_STORE_DIR = "${config.users.users.jonash.home}/.local/share/password-store";
  };

  # Enable shell completion for pass
  programs = {
    zsh.enable = lib.mkDefault true;  # Enable zsh by default
    bash.enableCompletion = true;
  };

  # Configure shell initialization for pass
  environment.shellInit = ''
    if [[ -n "''${ZSH_VERSION-}" ]]; then
      # ZSH
      source ${pkgs.pass}/share/zsh/site-functions/_pass
    elif [[ -n "''${BASH_VERSION-}" ]]; then
      # Bash
      source ${pkgs.pass}/share/bash-completion/completions/pass
    fi
  '';
}
