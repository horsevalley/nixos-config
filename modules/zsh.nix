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

      # Cursor shape changes
      cursor_block='\e[2 q'
      cursor_beam='\e[6 q'

      function set_cursor_shape() {
        case ''${KEYMAP:-main} in
          vicmd)
            echo -ne "$cursor_block"
            ;;
          viins|main)
            echo -ne "$cursor_beam"
            ;;
        esac
      }

      function zle-line-init() {
        echo -ne "$cursor_beam"
      }
      zle -N zle-line-init

      autoload -Uz add-zsh-hook
      add-zsh-hook precmd set_cursor_shape

      # Use vim keys in tab complete menu
      zmodload zsh/complist
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char

      # Load Starship prompt
      eval "$(starship init zsh)"

      # FZF settings
      export FZF_DEFAULT_OPTS="
        --height 80%
        --layout=reverse
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

      # Function to set FZF_TMUX_OPTS dynamically
      set_fzf_tmux_opts() {
        if [ -n "$TMUX" ]; then
          export FZF_TMUX=1
          export FZF_TMUX_OPTS="-p 80%,80%"
        else
          export FZF_TMUX=0
          unset FZF_TMUX_OPTS
        fi
      }

      # Call the function to set FZF_TMUX_OPTS
      set_fzf_tmux_opts

      # Add the function to precmd hook to update on new shell or tmux attach/detach
      add-zsh-hook precmd set_fzf_tmux_opts

      # Load fzf
      if [ -f "${pkgs.fzf}/share/fzf/completion.zsh" ]; then
        source "${pkgs.fzf}/share/fzf/completion.zsh"
      fi
      if [ -f "${pkgs.fzf}/share/fzf/key-bindings.zsh" ]; then
        source "${pkgs.fzf}/share/fzf/key-bindings.zsh"
      fi

      # Explicitly bind Ctrl-R to fzf-history-widget
      bindkey '^R' fzf-history-widget

      # Override fzf-history-widget function to use tmux if available
      fzf-history-widget() {
        local selected num
        setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
        selected=( $(fc -rl 1 | \
          FZF_DEFAULT_OPTS="--height ''${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=$LBUFFER +m" $(__fzfcmd)) )
        local ret=$?
        if [ -n "$selected" ]; then
          num=$selected[1]
          if [ -n "$num" ]; then
            zle vi-fetch-history -n $num
          fi
        fi
        zle reset-prompt
        return $ret
      }

      # Helper function to determine fzf command
      __fzfcmd() {
        [ -n "$TMUX_PANE" ] && { [ "''${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
          echo "fzf-tmux ''${FZF_TMUX_OPTS:--d''${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
      }
    '';
  };
  # Enable Starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[< ins >](bold green)";
        error_symbol = "[✗](bold red)";
        vicmd_symbol = "[< norm >](bold blue)";
      };
    };
  };
  # Ensure required packages are installed
  environment.systemPackages = with pkgs; [
    fzf
    fd
    bat
    tmux
    git
    starship
    gnupg
    pass
  ];
}
