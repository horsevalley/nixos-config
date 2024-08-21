{ config, pkgs, ... }:

{
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    inkscape
    gimp
    syncthing 
    insync
    newsboat
    home-manager
    rofi
    yt-dlp
    nvtopPackages.full
    inxi 
    glxinfo 
    signal-desktop 
    libnotify
    libvirt
    slock
    fastfetch # aesthetic sysinfo
    sdcv # console version of stardict

    # Productivity
    obsidian
    libreoffice

    # Linux utilities
    fzf
    bat
    ripgrep
    unzip
    p7zip
    fd
    ripgrep
    stow
    xclip
    jq
    ncdu
    tree
    tldr
    killall
    man

    # Programming languages and compilers
    gcc
    gnumake
    python3
    go
    rustc
    cargo
    nodejs_22

    # Audio
    wireplumber
    pulsemixer 
    youtube-music
    ncmpcpp

    # Video
    mpv
    mpd
    mpc-cli

    # Viewers
    zathura 
    nsxiv
    glow
    litemdview

    # Shell
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-autocomplete
    starship
    
    # Terminal emulators
    kitty
    st 

    # Editors
    vim 
    neovim 
    tmux 

    # File managers
    yazi
    lf
    xfce.thunar
    xfce.thunar-volman

    # Browsers
    qutebrowser
    librewolf


    # Email
    mutt-wizard
    neomutt
    curl
    isync
    msmtp
    lynx
    notmuch
    abook

    # Gaming
    bottles
    lutris
    heroic

    # Security
    pam_gnupg
    pass
    pass-nodmenu
    passExtensions.pass-otp
    pinentry-curses
    gpgme

    # System monitoring 
    htop 
    gotop 
    bottom 


    # Torrenting
    tremc 
    transmission 
    transmission-remote-gtk 


    # Silly programs
    cowsay
    figlet
    lolcat
    asciiquarium
    cmatrix

  ];

}
