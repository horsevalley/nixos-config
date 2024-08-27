{ config, pkgs, ... }:

{
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    git-lfs
    newsboat
    home-manager
    yt-dlp
    signal-desktop 
    libnotify
    libvirt
    slock
    sdcv # console version of stardict
    bc # basic calculator 
    unclutter # hides mouse when idle 
    arandr  
    dmenu
    intelmetool # used to optimize system settings for intel chipsets
    swaylock
    swaylock-effects
    socat
    gtk-layer-shell
    pango
    libdbusmenu-gtk3
    cairo
    glibc

    # Aesthetic sysinfo
    fastfetch 
    neofetch 
    inxi 
    glxinfo 
    nvtopPackages.full
    mediainfo

    # Productivity
    obsidian
    libreoffice
    mnemosyne # spaced repetiton software 
    calcurse

    # File sync
    syncthing 
    insync

    # Networking and utilities
    networkmanagerapplet

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

    # DevOps programs and utilities
    kubernetes
    kubectl
    k3s

    # Audio
    wireplumber
    pulsemixer 
    youtube-music
    ncmpcpp
    playerctl

    # Video
    mpv
    mpd
    mpc-cli
    ffmpeg

    # Photo/image 
    gimp
    inkscape
    imagemagick
    ueberzug
    ffmpegthumbnailer
    poppler

    # Viewers
    zathura 
    nsxiv
    glow
    litemdview
    file

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
    tmux 

    # File managers
    yazi
    lf
    pcmanfm

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
    kdePackages.polkit-kde-agent-1

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
