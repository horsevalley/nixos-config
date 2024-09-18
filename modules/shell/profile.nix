{ config, lib, pkgs, ... }:

{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    TERMINAL_PROG = "Kitty";
    BROWSER = "qutebrowser";
    VIDEOPLAYER = "mpv";
    MUSICPLAYER = "ncmpcpp";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_DATA_DIRS = "$HOME/.local/share" "$XDG_DATA_DIRS";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DEFAULT_PDF_VIEWER = "zathura";
    XDG_DEFAULT_IMAGE_VIEWER = "nsxiv";
    XDG_DEFAULT_VIDEO_PLAYER = "mpv";
    XDG_DEFAULT_BROWSER = "qutebrowser";
    NOTMUCH_CONFIG = "$XDG_CONFIG_HOME/notmuch-config";
    GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0";
    WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
    INPUTRC = "$XDG_CONFIG_HOME/shell/inputrc";
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    GNUPGHOME = "$HOME/.gnupg";
    WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
    KODI_DATA = "$XDG_DATA_HOME/kodi";
    PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
    TMUX_TMPDIR = "$XDG_RUNTIME_DIR";
    ANDROID_SDK_HOME = "$XDG_CONFIG_HOME/android";
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    GOPATH = "$XDG_DATA_HOME/go";
    GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
    ANSIBLE_CONFIG = "$XDG_CONFIG_HOME/ansible/ansible.cfg";
    UNISON = "$XDG_DATA_HOME/unison";
    HISTFILE = "$XDG_DATA_HOME/history";
    # MBSYNCRC = "$XDG_CONFIG_HOME/mbsync/config";
    ELECTRUMDIR = "$XDG_DATA_HOME/electrum";
    PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
    SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
    SECOND_BRAIN = "$HOME/obsidian";
    LYNX_CFG = "$HOME/.config/lynx/lynx.cfg";
    LYNX_CFG_PATH = "$HOME/.config/lynx";
    DICS = "$XDG_DATA_HOME/stardict/dic";
    SD_DATA_PATH = "$XDG_DATA_HOME/stardict/dic";
    SUDO_ASKPASS = "$HOME/.local/bin/rofi-passmenu";
    FZF_DEFAULT_OPTS = "--layout=reverse --height 40%";
    LESS = "R";
    LESSOPEN = lib.mkForce "| ${pkgs.highlight}/bin/highlight -O ansi %s 2>/dev/null";
    QT_QPA_PLATFORMTHEME = "gtk2";
    MOZ_USE_XINPUT2 = "1";
    AWT_TOOLKIT = "MToolkit wmname LG3D";
    BAT_THEME = "Catppuccin Mocha";
    SNIPPETS_FILE = "$HOME/.local/bin/snippets";
    ANTHROPIC_API_KEY="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";
    NEWSBOAT_CONFIG_DIR = "$HOME/.config/newsboat";
    ABOOK_CONFIG = "$XDG_CONFIG_HOME/abook/abookrc";

  };

  environment.shellInit = ''
    # LESS color settings
    export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
    export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
    export LESS_TERMCAP_me="$(printf '%b' '[0m')"
    export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
    export LESS_TERMCAP_se="$(printf '%b' '[0m')"
    export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
    export LESS_TERMCAP_ue="$(printf '%b' '[0m')"

    # Java settings
    export _JAVA_AWT_WM_NONREPARENTING=1

    # Set SSH_AUTH_SOCK
    export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
  '';

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    highlight
    gnupg
  ];

  # Enable xdg mime
  xdg.mime.enable = true;

  # Add ~/.local/bin to PATH
  environment.pathsToLink = [ "/share/zsh" ];
  environment.extraOutputsToInstall = [ "man" "doc" ];
  environment.sessionVariables = {
    PATH = [ 
      "$HOME/.local/bin"
    ];
  };
}
