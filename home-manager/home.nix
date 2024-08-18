{ config, pkgs, ... }:

{
  home.username = "jonash";
  home.homeDirectory = "/home/jonash";

  # targets.genericLinux.enable = true; # Enable this on non-NixOS 

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".local/share/zsh/zsh-autosuggestions".source =
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
    ".local/share/zsh/zsh-fast-syntax-highlighting".source =
      "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    ".local/share/zsh/nix-zsh-completions".source =
      "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix";
  };

  home.sessionVariables = {
     EDITOR = "nvim";
     VISUAL = "nvim";
  };

  programs.git = {
    enable = true;
    userName = "Jonas Hestdahl";
    userEmail = "hestdahl@gmail.com";
    aliases = {
      gP = "push";
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    #envExtra = ''
      #export SOMEZSHVARIABLE="something"
    #'';
  };

  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    cursorTheme.name = "Bibata-Modern-Ice";
    iconTheme.name = "GruvboxPlus";
  }

  xdg.mimeApps.defaultApplications = {
    "video/*" = [ "mpv.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/jpg" = [ "mpv.desktop" ];
    "image/*" = [ "nsxiv.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "text/html" = [ "qutebrowser.desktop" ];
    "x-scheme-handler/http" = [ "qutebrowser.desktop" ];
    "x-scheme-handler/https" = [ "qutebrowser.desktop" ];
};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
