{ config, pkgs, ... }:

{
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    newsboat
    home-manager
    yt-dlp
    nvtopPackages.full
    signal-desktop 
    libnotify
    libvirt
    slock
    sdcv # console version of stardict
    bc # basic calculator 
    unclutter # hides mouse when idle 
    arandr  
    dmenu
    # greetd.tuigreet
    plymouth
    catppuccin-plymouth
    catppuccin-sddm

    # Wayland-specific packages
    wl-clipboard
    waybar
    jq          # Not Wayland-specific, but needed for some Waybar modules
    grim        # For screenshots (optional)
    slurp       # For area selection (optional)
    # wofi
    # wofi-pass
    rofi-wayland
    swww # Simple Wayland Wallpaper Watcher

    # Aesthetic sysinfo
    fastfetch 
    neofetch 
    inxi 
    glxinfo 

    # Productivity
    obsidian
    libreoffice
    mnemosyne # spaced repetiton software 

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

    # Video
    mpv
    mpd
    mpc-cli
    ffmpeg

    # Photo/image 
    gimp
    inkscape
    imagemagick

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
