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

    shellInit = ''
      # Function to clear the screen with ctrl-l
      function clear_screen() {
        if [[ -n "$TMUX" ]]; then
          # If inside tmux, use tmux clear-screen command
          tmux clear-screen
        else
          # If not inside tmux, use clear command
          clear
        fi
      }

      # FZF options
      export FZF_CTRL_R_OPTS="
        --preview 'echo {}' --preview-window up:3:hidden:wrap
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
    '';

    interactiveShellInit = ''
      # vi mode
      bindkey -v
      export KEYTIMEOUT=1

      # Use vim keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      # Change cursor shape for different vi modes
      function zle-keymap-select() {
        case $KEYMAP in
          vicmd) echo -ne '\e[1 q';;
          viins|main) echo -ne '\e[5 q';;
        esac
      }
      zle -N zle-keymap-select
      zle-line-init() {
        zle -K viins
        echo -ne "\e[5 q"
      }
      zle -N zle-line-init
      echo -ne '\e[5 q'
      preexec() { echo -ne '\e[5 q' ;}

      # Use lf to switch directories and bind it to ctrl-o
      lfcd () {
        tmp="$(mktemp -uq)"
        trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
        lf -last-dir-path="$tmp" "$@"
        if [ -f "$tmp" ]; then
          dir="$(cat "$tmp")"
          [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
        fi
      }

      bindkey -s '^o' '^ulfcd\n'
      bindkey -s '^a' '^ubc -lq\n'
      bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'
      bindkey '^[[P' delete-char

      # Edit line in vim with ctrl-e
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line
      bindkey -M vicmd '^[[P' vi-delete-char
      bindkey -M vicmd '^e' edit-command-line
      bindkey -M visual '^[[P' vi-delete

      # Load kubectl completions
      source <(kubectl completion zsh)

      # Shell integrations
      eval "$(fzf --zsh)"

      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

      # Load Starship
      eval "$(starship init zsh)"

      # Functions from aliasrc
      function gcm() {
        git commit -m "$1"
      }

      function urlencode () {
        local str="$*"
        local encoded=""
        local i c x
        for (( i = 0; i<''${#str}; i++ )); do
          c=''${str:$i:1}
          case "$c" in
            [-_.~a-zA-Z0-9] ) x="$c" ;;
            * ) x=$(printf '%%%02X' "'$c") ;;
          esac
          encoded+="$x"
        done
        echo "$encoded"
      }

      function duck () {
        declare url=$(urlencode "$*")
        lynx "https://duckduckgo.com/lite?q=$url"
      }

      function googleSearch () {
        declare url=$(urlencode "$*")
        lynx "https://google.com/search?q=$url"
      }
    '';

    loginShellInit = ''
      # Various options
      setopt autocd
      setopt interactive_comments
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
      setopt hist_ignore_dups
      setopt hist_find_no_dups

      # History configuration
      HISTSIZE=100000000
      SAVEHIST=$HISTSIZE
      HISTFILE="$XDG_DATA_HOME/history"
      HISTDUP=erase
    '';
  };

  # Additional package dependencies
  environment.systemPackages = with pkgs; [
    fzf
    bat
    fd
    lf
    starship
    tmux
    kubectl
    lynx
  ];

  # Enable Starship
  programs.starship.enable = true;
}
