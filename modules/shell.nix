{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    syntaxHighlighting.enable = true;
    shellInit = ''
    # Source profile file
    if [ -f "$HOME/.config/shell/profile" ]; then
      source "$HOME/.config/shell/profile"
    fi

    # Source aliases file
    if [ -f "$HOME/.config/shell/aliasrc" ]; then
      source "$HOME/.config/shell/aliasrc"
    fi
  '';
};
}
