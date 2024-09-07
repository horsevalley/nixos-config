{ config, pkgs, lib, ... }:

{
  # Install necessary packages
  environment.systemPackages = with pkgs; [
    gnupg    # The GNU Privacy Guard suite
    pinentry # Program for entering passphrases
  ];

  # Configure the GPG agent
  programs.gnupg.agent = {
    enable = true;           # Enable the GPG agent
    enableSSHSupport = true; # Use GPG agent for SSH key management
    pinentryPackage = pkgs.pinentry-curses; # Use the terminal-based pinentry program
    # Other options: pkgs.pinentry-gtk2, pkgs.pinentry-qt, pkgs.pinentry-gnome3 for graphical interfaces
  };

  # Enable pam-gnupg for automatic GPG key unlocking
  security.pam.services = {
    # Configure for login
    login.gnupg = {
      enable = true;      # Enable pam-gnupg for login
      noAutostart = false; # Start GPG agent automatically
      storeOnly = false;   # Allow using stored passphrases, not just storing them
    };
    # Configure for sudo (same settings as login)
    sudo.gnupg = {
      enable = true;
      noAutostart = false;
      storeOnly = false;
    };
  };

  # Configure GPG agent settings
  programs.gnupg.agent.settings = {
    default-cache-ttl = 34560000; # Cache time for GPG keys (in seconds)
    max-cache-ttl = 34560000;     # Maximum cache time for GPG keys
    # 34,560,000 seconds = 400 days
  };

  # Optional: Set environment variables for GPG
  # Uncomment and modify as needed
  # environment.variables = {
  #   GPGKEY = "YOUR_GPG_KEY_ID"; # Set default GPG key
  # };

  # Configure shell initialization for GPG
  environment.shellInit = ''
    # Source GPG completion scripts based on the current shell
    if [[ -n "''${ZSH_VERSION-}" ]]; then
      # For Zsh
      source ${pkgs.gnupg}/share/zsh/site-functions/_gpg
    elif [[ -n "''${BASH_VERSION-}" ]]; then
      # For Bash
      source ${pkgs.gnupg}/share/bash-completion/completions/gpg
    fi
  '';

  # Enable GPG agent socket for pam-gnupg
  systemd.user.sockets.gpg-agent = {
    enable = true;
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = "%t/gnupg/S.gpg-agent"; # Socket path
      FileDescriptorName = "std";
      SocketMode = "0600";   # Set socket permissions
      DirectoryMode = "0700"; # Set directory permissions
    };
  };
}
