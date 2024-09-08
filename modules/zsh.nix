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
      # Load Starship prompt
      eval "$(starship init zsh)"

      # FZF settings
      # CTRL-/ to toggle small preview window to see the full command
      # CTRL-Y to copy the command into clipboard using pbcopy
      export FZF_CTRL_R_OPTS="
        --preview 'echo {}' --preview-window up:3:hidden:wrap
        --bind 'ctrl-/:toggle-preview'
        --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
        --color header:italic
        --history-size=1000000
        --header 'Press CTRL-Y to copy command into clipboard'"
      # Preview file content using bat (https://github.com/sharkdp/bat)
      export FZF_CTRL_T_OPTS="
        --walker-skip .git,node_modules,target
        --preview 'bat -n --color=always {}'
        --bind 'ctrl-/:change-preview-window(down|hidden|)'"
      export FZF_TMUX_OPTS="-p"
      export FZF_DEFAULT_COMMAND="fd --type f"

      # Load fzf
      if [ -n "''${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      # Explicitly bind Ctrl-R to fzf-history-widget
      bindkey '^R' fzf-history-widget
    '';
    # shellInit = ''
    #   # Your shell initialization code here
    # '';
    # loginShellInit = ''
    #   # Your login shell initialization code here
    # '';
    # promptInit = "";  # We're using Starship, so we can leave this empty
  };

  # Additional package dependencies
  # environment.systemPackages = with pkgs; [
  #   starship
  #   fzf
  #   fd
  #   bat
  #   # Add other packages you need
  # ];

  # Enable Starship
   programs.starship.enable = true;
}
