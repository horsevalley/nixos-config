{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    wget
    curl
    newsboat # RSS Reader
    # home-manager
    yt-dlp # Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
    libnotify # A library that sends desktop notifications to a notification daemon
    libvirt # A toolkit to interact with the virtualization capabilities of recent versions of Linux and other OS
    unclutter # hides mouse when idle 
    arandr # A simple visual front end for XRandR
    # dmenu # A generic, highly customizable, and efficient menu for the X Window System
    intelmetool # used to optimize system settings for intel chipsets
    socat
    gtk-layer-shell
    pango
    libdbusmenu-gtk3
    cairo # A 2D graphics library with support for multiple output devices
    lm_sensors # Tools for reading hardware sensors
    upower # A D-Bus service for power management
    ookla-speedtest
    xdg-utils # for xdg-open
    slop # Queries a selection from the user and prints to stdout
    wev # Wayland Event Viewer
    wtype # xdotool type for wayland
    libinput # Handles input devices in Wayland compositors and provides a generic X.Org input driver
    zellij # A terminal workspace with batteries included
    nix-prefetch # Prefetch any fetcher function call, e.g. package sources
    nix-prefetch-github # Prefetch sources from github

    # Git
    git
    git-lfs
    gh # GitHub CLI tool
    lazygit # Simple terminal UI for git commands

    # Social
    signal-desktop 
    discord
    slack

    # Productivity
    libreoffice
    mnemosyne # spaced repetiton software 
    calcurse
    sdcv # console version of stardict
    bc # basic calculator 
    speedcrunch # fast, high precision, cross-platform calculator
    teams-for-linux

    # File sync
    syncthing 
    insync

    # Networking and utilities
    networkmanagerapplet
    nmap

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
    stow
    xclip
    tree
    tldr
    killall
    man
    highlight # Source code highlighting tool

    # Programming languages and compilers
    gcc
    glibc # The GNU C Library
    gnumake
    python3
    go
    rustc
    rustup 
    cargo
    nodejs_22
    R
    texliveFull # TeX Live environment
    pandoc
    latex2html
    hugo # A fast and modern static website engine
    groff
    ghostscript
    gopls
    nixpkgs-fmt
    alejandra
    nixd
    jq # A lightweight and flexible command-line JSON processor
    yq # Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents
    prettier-d-slim # Makes prettier fast

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
    # obs-cli # command-line remote control for OBS
    pipe-viewer # lightweight youtube cli

    # Photo/image 
    gimp
    inkscape
    imagemagick
    ueberzug
    ffmpegthumbnailer
    libsForQt5.ffmpegthumbs
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
    zsh-fast-syntax-highlighting
    zsh-autosuggestions
    zsh-autocomplete
    starship
    
    # Terminal emulators
    kitty

    # Editors
    vim 
    neovim
    tmux 

    # File managers
    # yazi
    lf
    pcmanfm

    # Browsers
    qutebrowser
    librewolf
    firefox
    widevine-cdm

    # Email
    # mutt-wizard
    # neomutt
    # curl
    # isync
    # msmtp
    # lynx
    # notmuch
    # abook

    # Security
    pam_gnupg
    pass-wayland
    passExtensions.pass-otp
    pinentry-curses
    gpgme
    kdePackages.polkit-kde-agent-1
    zbar

    # System monitoring and utils
    htop-vim
    gotop 
    bottom 
    nethogs
    pstree # Show the set of running processes as a tree
    btop
    fastfetch 
    neofetch 
    inxi 
    glxinfo 
    nvtopPackages.full
    mediainfo

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
