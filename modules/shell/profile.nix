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
    GOPATH = "$HOME/.local/share/go";   
    # GOPATH = "$XDG_DATA_HOME/go";
    GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
    ANSIBLE_CONFIG = "$XDG_CONFIG_HOME/ansible/ansible.cfg";
    UNISON = "$XDG_DATA_HOME/unison";
    HISTFILE = "$XDG_DATA_HOME/history";
    # MBSYNCRC = "$XDG_CONFIG_HOME/mbsync/config";
    ELECTRUMDIR = "$XDG_DATA_HOME/electrum";
    PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
    SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
    SECOND_BRAIN = "$GHREPOS/obsidian";
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
    NEWSBOAT_CONFIG_DIR = "$HOME/.config/newsboat";
    ABOOK_CONFIG = "$XDG_CONFIG_HOME/abook/abookrc";
    PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    GRIM_DEFAULT_DIR = "~/Pictures/Screenshots/";
    REPOS = "$HOME/repos/";
    DOTFILES = "$HOME/repos/github/jonashestdahl/dotfiles-nix";
    GHREPOS = "$HOME/repos/github/jonashestdahl";
    GITUSER = "jonashestdahl";
    SCRIPTS = "$HOME/.local/bin";
    GITHUB_USER = "horsevalley";
    AGE_PUBLIC = "age1metul8425dkcs8vf9w79fa7qp86llceyshxh95yrxr445pqv44uq9ceqqx";
    SOPS_AGE_KEY_FILE = "~/.age/age.agekey";
    ANTHROPIC_API_KEY = "${config.sops.secrets.anthropic_api_key.path}";
    GITHUB_TOKEN = "${config.sops.secrets.github_token.path}";

  };

  environment.shellInit = ''
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

  # Add ~/.local/bin to PATH
  environment.pathsToLink = [ "/share/zsh" ];
  environment.extraOutputsToInstall = [ "man" "doc" ];
  environment.sessionVariables = {
    PATH = [ 
      "$HOME/.local/bin"
    ];
  };
}
