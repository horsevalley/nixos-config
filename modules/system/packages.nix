{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    git-lfs
    newsboat
    # home-manager
    yt-dlp
    libnotify
    libvirt
    slock
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
    # dunst
    lm_sensors
    upower
    swaynotificationcenter
    ookla-speedtest
    xdg-utils # for xdg-open
    slop

    # Aesthetic sysinfo
    fastfetch 
    neofetch 
    inxi 
    glxinfo 
    nvtopPackages.full
    mediainfo

    # Social
    signal-desktop 

    # Productivity
    obsidian
    libreoffice
    mnemosyne # spaced repetiton software 
    calcurse
    sdcv # console version of stardict
    bc # basic calculator 

    # File sync
    syncthing 
    insync

    # Networking and utilities
    networkmanagerapplet

    # Linux utilities
    fzf # general-purpose command-line fuzzy finder
    ncdu # console disk usage analyzer for quick space management
    fd # simple and fast file search tool, enhancing the Unix find command
    eza # modern replacement for ls, enhancing file listing with better defaults
    bat # cat clone with syntax highlighting and Git integration for the command-line
    dog # modern, feature-rich DNS client for the command-line
    dust # visualizes disk usage with an emphasis on clarity, acting as a more intuitive du
    duf # modern disk usage utility for the command-line with an intuitive interface
    xh # modern, feature-rich DNS client for the command-line
    ripgrep # line-oriented search tool that recursively searches the current directory for a regex pattern
    unzip
    p7zip
    stow
    xclip
    tree
    tldr
    killall
    man
    highlight # Source code highlighting tool


    # Programming languages and compilers
    gcc
    gnumake
    python3
    go
    rustc
    cargo
    nodejs_22
    R
    rPackages.tinytex

    # DevOps programs and utilities
    kubernetes
    kubectl
    k3s

    # Audio
    wireplumber
    pulsemixer 
    mpd
    mpc-cli
    ncmpcpp
    youtube-music
    playerctl
    pamixer

    # Video
    mpv
    ffmpeg
    wf-recorder # Utility program for screen recording of wlroots-based compositors
    # jellyfin
    # jftui
    obs-studio

    # Photo/image 
    gimp
    inkscape
    imagemagick
    ueberzug
    ffmpegthumbnailer
    poppler
    # exif # A utility to read and manipulate EXIF data in digital photographs
    # exiftool # A tool to read, write and edit EXIF meta information
    # exiftags # Displays EXIF data from JPEG files
    # exifprobe # Tool for reading EXIF data from image files produced by digital cameras
    # exiflooter # Finds geolocation on all image urls and directories

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
    neovim
    tmux 

    # File managers
    yazi
    lf
    pcmanfm

    # Browsers
    qutebrowser
    librewolf
    firefox

    # Email
    mutt-wizard
    neomutt
    curl
    isync
    msmtp
    lynx
    notmuch
    abook

    # Security
    pam_gnupg
    # pass
    # pass-nodmenu
    pass-wayland
    passExtensions.pass-otp
    pinentry-curses
    gpgme
    kdePackages.polkit-kde-agent-1
    zbar

    # System monitoring 
    htop-vim
    gotop 
    bottom 

    # Torrenting
    tremc 
    transmission 
    transmission-remote-gtk 

    # X11
    xorg.xorgserver
    xorg.xinit
    wl-clipboard-x11

    # Silly programs
    cowsay
    figlet
    lolcat
    asciiquarium
    cmatrix

  ];

}
