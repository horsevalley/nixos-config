{ config, lib, pkgs, ... }:

let
  aliasrc = import ./aliasrc.nix { inherit config lib pkgs; };
  profile = import ./profile.nix { inherit config lib pkgs; };
in
{
  imports = [ aliasrc profile ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    interactiveShellInit = ''
      # Enable vi mode
      bindkey -v
      export KEYTIMEOUT=1

      # Use vim keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history

      # Change cursor shape for different vi modes
      function zle-keymap-select {
        if [[ ''${KEYMAP} == vicmd ]] ||
           [[ $1 = 'block' ]]; then
          echo -ne '\e[2 q'
        elif [[ ''${KEYMAP} == main ]] ||
             [[ ''${KEYMAP} == viins ]] ||
             [[ ''${KEYMAP} = ''' ]] ||
             [[ $1 = 'beam' ]]; then
          echo -ne '\e[6 q'
        fi
      }
      zle -N zle-keymap-select

      # Use beam shape cursor on startup.
      echo -ne '\e[6 q'

      # Use beam shape cursor for each new prompt.
      preexec() { echo -ne '\e[6 q' ;}

      # Bind Ctrl+L to clear-screen
      bindkey '^L' clear-screen

      # Bind Ctrl+A to beginning-of-line
      bindkey '^A' beginning-of-line

      # Load Starship prompt
      eval "$(starship init zsh)"
    '';

    shellInit = ''
      # Your shell initialization code here
    '';

    loginShellInit = ''
      # Your login shell initialization code here
    '';

    promptInit = "";  # We're using Starship, so we can leave this empty
  };

  # Additional package dependencies
  environment.systemPackages = with pkgs; [
    starship
    # Add other packages you need
  ];

  # Enable Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
