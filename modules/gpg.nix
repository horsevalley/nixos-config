{ config, pkgs, lib, ... }:

{
  # Install necessary packages for GPG functionality
  environment.systemPackages = with pkgs; [
    gnupg    # The GNU Privacy Guard suite for encryption and signing
    pinentry # Program for secure passphrase entry
    pam_gnupg
  ];

  # Configure the GPG agent
  programs.gnupg.agent = {
    enable = lib.mkForce true;           # Force enable the GPG agent
    enableSSHSupport = lib.mkForce true; # Force enable GPG agent for SSH key management
    pinentryPackage = pkgs.pinentry-curses; # Use the terminal-based pinentry program
    # Other pinentry options:
    # pkgs.pinentry-gtk2 - for GTK-based desktop environments
    # pkgs.pinentry-qt - for Qt-based desktop environments
    # pkgs.pinentry-gnome3 - for GNOME desktop environment
  };

  # Configure PAM (Pluggable Authentication Modules) for GPG
  # This allows for GPG key unlocking during login and sudo
  security.pam.services = {
    # Configure GPG for login
    login.gnupg = {
      enable = lib.mkForce true;        # Force enable GPG support for login
      storeOnly = lib.mkForce false;    # Allow using stored passphrases, not just storing them
      noAutostart = lib.mkForce false;  # Start GPG agent automatically on login
    };
    # Configure GPG for sudo (same settings as login)
    sudo.gnupg = {
      enable = lib.mkForce true;
      storeOnly = lib.mkForce false;
      noAutostart = lib.mkForce false;
    };
  };

  # Configure GPG agent settings
  programs.gnupg.agent.settings = {
    default-cache-ttl = 34560000; # Cache time for GPG keys (in seconds)
    max-cache-ttl = 34560000;     # Maximum cache time for GPG keys
    # 34,560,000 seconds = 400 days
    # Adjust these values based on your security needs
  };

  # Optional: Set environment variables for GPG
  # Uncomment and modify as needed
  # environment.variables = {
  #   GPGKEY = "YOUR_GPG_KEY_ID"; # Set default GPG key
  # };

  # Configure shell initialization for GPG
  # This adds GPG completion to your shell
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
  # This allows the GPG agent to communicate with PAM
  systemd.user.sockets.gpg-agent = {
    enable = true;
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = "%t/gnupg/S.gpg-agent"; # Socket path
      FileDescriptorName = "std";
      SocketMode = "0600";   # Set socket permissions (user read/write only)
      DirectoryMode = "0700"; # Set directory permissions (user read/write/execute only)
    };
  };
}
