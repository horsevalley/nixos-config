{ config, pkgs, lib, ... }:

{
  # Install pass (password store)
  environment.systemPackages = with pkgs; [
    pass
  ];

  # Set the PASSWORD_STORE_DIR environment variable
  # Use $XDG_DATA_HOME to maintain consistency with zsh.nix and profile.nix
  environment.variables = {
    PASSWORD_STORE_DIR = lib.mkForce "$XDG_DATA_HOME/password-store";
  };

  # Enable bash completion for pass
  programs.bash.enableCompletion = true;

  # Add shell initialization for pass
  environment.shellInit = ''
    if [[ -n "''${ZSH_VERSION-}" ]]; then
      # For Zsh
      source ${pkgs.pass}/share/zsh/site-functions/_pass
    elif [[ -n "''${BASH_VERSION-}" ]]; then
      # For Bash
      source ${pkgs.pass}/share/bash-completion/completions/pass
    fi
  '';
}
