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
      export FZF_DEFAULT_OPTS="
        --height 80%
        --layout=reverse
        --width 80%
        --preview 'echo {}'
        --preview-window up:3:hidden:wrap
        --bind 'ctrl-/:toggle-preview'
        --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
        --color header:italic
        --history-size=1000000
        --header 'Press CTRL-Y to copy command into clipboard'"
      export FZF_CTRL_T_OPTS="
        --walker-skip .git,node_modules,target
        --preview 'bat -n --color=always {}'
        --bind 'ctrl-/:change-preview-window(down|hidden|)'"
      export FZF_TMUX_OPTS="-p"
      export FZF_DEFAULT_COMMAND="fd --type f"
      # Load fzf
      if [ -f "${pkgs.fzf}/share/fzf/completion.zsh" ]; then
        source "${pkgs.fzf}/share/fzf/completion.zsh"
      fi
      if [ -f "${pkgs.fzf}/share/fzf/key-bindings.zsh" ]; then
        source "${pkgs.fzf}/share/fzf/key-bindings.zsh"
      fi
      # Explicitly bind Ctrl-R to fzf-history-widget
      bindkey '^R' fzf-history-widget
    '';
  };
  # Enable Starship
  programs.starship.enable = true;
  # Ensure fzf is installed
  environment.systemPackages = with pkgs; [
    fzf
    fd
    bat
  ];
}
