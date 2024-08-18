# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./audio.nix
      ./desktop.nix
      ./editor.nix
      ./fonts.nix
      ./graphics.nix
      ./hardware.nix
      ./keyboard.nix
      ./localization.nix
      ./networking.nix
      ./packages.nix
      ./security.nix
      ./services.nix
      ./shell.nix
      ./system.nix
      ./users.nix
      ./variables.nix
      # inputs.home-manager.nixosModules.home-manager
    ];

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     jonash = import ./home.nix;
  #   };
  # };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "horsepowr-nixos"; # Define your hostname.

  # # Enable networking
  # networking.networkmanager.enable = true;

  # # Set your time zone.
  # time.timeZone = "Europe/Oslo";
 
  # # Enable CUPS to print documents
  # services.printing.enable = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  #
  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "nb_NO.UTF-8";
  #   LC_IDENTIFICATION = "nb_NO.UTF-8";
  #   LC_MEASUREMENT = "nb_NO.UTF-8";
  #   LC_MONETARY = "nb_NO.UTF-8";
  #   LC_NAME = "nb_NO.UTF-8";
  #   LC_NUMERIC = "nb_NO.UTF-8";
  #   LC_PAPER = "nb_NO.UTF-8";
  #   LC_TELEPHONE = "nb_NO.UTF-8";
  #   LC_TIME = "nb_NO.UTF-8";
  # };

  # security.rtkit.enable = true;

#  # Enable sound.
#    hardware.pulseaudio.enable = false;
#    services.pipewire = {
#      enable = true;
#      pulse.enable = true;
#      alsa.enable = true;
#      alsa.support32Bit = true;
#      jack.enable = true;
#    };
#
#    # MPD settings
#   services.mpd = {
#   enable = true;
#   user = "jonash";
#   musicDirectory = "/home/jonash/Music";
#   network = {
#     listenAddress = "any"; # This allows connections from other devices on your network
#     port = 6600; # Use a different port
#   };
#   extraConfig = ''
#   zeroconf_enabled "no"
#     audio_output {
#       type "pipewire"
#       name "PipeWire Sound Server"
#     }
#     #audio_output {
#      # type "pulse"
#       #name "PulseAudio Sound Server"
#     }
#     #audio_output {
#      # type "alsa"
#       #name "ALSA Sound Server"
#    # }
#   '';
# };

#   # Enable X11
#   services.xserver.enable = true;
#
#   # Enable GNOME Desktop Environment
#   services.xserver.displayManager.gdm.enable = true;
#   services.xserver.desktopManager.gnome.enable = true;
#
#   # Disable Wayland
#   services.xserver.displayManager.gdm.wayland = false;
#
#   # Exclude GNOME packages that are Wayland-specific
#   environment.gnome.excludePackages = with pkgs.gnome; [
#     mutter
#     gnome-shell
# ];

  # # Force X11 for GNOME session
  # services.displayManager.defaultSession = "gnome-xorg";

  # # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "no";
  #   variant = "nodeadkeys";
  #   options = "eurosign:e,caps:escape";
  # };
  #
  # # Configure console keymap
  # console.keyMap = "no";

  # # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jonash = {
  #   isNormalUser = true;
  #   description = "Jonas Hestdahl";
  #   shell = pkgs.zsh;
  #   extraGroups = [ "networkmanager" "wheel" "user" "audio" "video" "input" "lib" "mpd" ];
  #   packages = with pkgs; [];
  # };

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # Enable Experimental Features
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   xorg.xorgserver
  #   xorg.xinit
  #   gnome.gnome-terminal
  #   gnome.gnome-tweaks
  #   gnome.gnome-software
  #   gnome.gnome-applets
  #   gnome.gnome-common
  #   gnome.gnome-session
  #   gnome.gnome-session-ctl
  #   gnome.gnome-keyring
  #   gnome-desktop
  #   gnome-extension-manager
  #   vim 
  #   neovim 
  #   tmux 
  #   wget
  #   curl
  #   git
  #   kitty
  #   starship
  #   zsh-syntax-highlighting
  #   zsh-autosuggestions
  #   zsh-autocomplete
  #   fzf
  #   bat
  #   ripgrep
  #   qutebrowser
  #   unzip
  #   p7zip
  #   yazi
  #   lf
  #   starship
  #   fzf
  #   bat
  #   fd
  #   ripgrep
  #   zsh
  #   unzip
  #   youtube-music
  #   stow
  #   xclip
  #   neovim
  #   pam_gnupg
  #   ncmpcpp
  #   mpv
  #   mpd
  #   mpc-cli
  #   mutt-wizard
  #   neomutt
  #   curl
  #   isync
  #   msmtp
  #   lynx
  #   notmuch
  #   abook
  #   pass
  #   passExtensions.pass-otp
  #   insync
  #   inkscape
  #   gimp
  #   gcc
  #   gnumake
  #   python3
  #   go
  #   rustc
  #   cargo
  #   nodejs_22
  #   newsboat
  #   nsxiv
  #   home-manager
  #   obsidian
  #   cmatrix
  #   tldr
  #   glow
  #   cowsay
  #   figlet
  #   lolcat
  #   asciiquarium
  #   glow
  #   litemdview
  #   rofi
  #   yt-dlp
  #   st 
  #   zathura 
  #   tremc 
  #   transmission 
  #   transmission-remote-gtk 
  #   syncthing 
  #   pulsemixer 
  #   htop 
  #   gotop 
  #   bottom 
  #   nvtopPackages.full
  #   inxi 
  #   glxinfo 
  #   signal-desktop 
  #   libnotify
  #   libvirt
  #   slock
  #   obsidian
  #   xfce.thunar
  #   xfce.thunar-volman
  #   fastfetch
  #   youtube-music
  #   killall
  #   man
  #   pass-nodmenu
  #   pinentry-curses
  #   jq
  #   wireplumber
  #
  # ];

  # Set SUID bit on slock
  security.wrappers.slock = {
    owner = "root";
    group = "root";
    source = "${pkgs.slock}/bin/slock";
    capabilities = "cap_ipc_lock+ep";
  };

  # # Nerdfonts
  # fonts = {
  #   fontDir.enable = true;
  #   packages = with pkgs; [
  #     (nerdfonts.override { fonts = [ "Meslo" ]; })
  #   ];
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

#   programs.zsh = {
#     enable = true;
#     enableCompletion = true;
#     enableBashCompletion = true;
#     syntaxHighlighting.enable = true;
#     shellInit = ''
#     # Source profile file
#     if [ -f "$HOME/.config/shell/profile" ]; then
#       source "$HOME/.config/shell/profile"
#     fi
#
#     # Source aliases file
#     if [ -f "$HOME/.config/shell/aliasrc" ]; then
#       source "$HOME/.config/shell/aliasrc"
#     fi
#   '';
# };

#   # Enable neovim
#   programs.neovim = {
#     enable = true;
#     viAlias = true;
#     vimAlias = true;
# };

  # # Enable the OpenSSH daemon.
  #  services.openssh.enable = true;

  # # System-wide environment variables
  # environment.variables = {
  #   EDITOR = "nvim";
  #   VISUAL = "nvim";
  #   TERMINAL = "kitty";
  #   BROWSER = "qutebrowser";
  # };

# # Set the custom path for .desktop files
#   environment.sessionVariables = {
#     XDG_DATA_DIRS = [ 
#       "/home/jonash/.local/share"
#       "$XDG_DATA_DIRS"
#     ];
#   };

  xdg.mime.enable = true;

# Enable the Syncthing service
  services.syncthing = {
    enable = true;
    user = "jonash";  # Replace with your actual username
    dataDir = "/mnt/IronWolf8TB/Syncthing";  # Adjust this path as needed
    #configDir = "/home/your_username/.config/syncthing";
    #overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    #overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    #devices = {
      # You can define your devices here if you want
      # "device-id" = {
      #   id = "device-id";
      #   name = "device-name";
      #   addresses = [ "tcp://ip:port" ];
      # };
    };
    #folders = {
      # You can define your sync folders here
      # "label" = {
      #   path = "/path/to/folder";
      #   devices = [ "device-id" ];
      # };
    #};
  #};

# Optionally, open firewall ports for Syncthing
  #networking.firewall.allowedTCPPorts = [ 22000 ];
  #networking.firewall.allowedUDPPorts = [ 22000 21027 ];


#   # GRAPHICS SETTINGS
#   # Enable NVIDIA Drivers
#   services.xserver.videoDrivers = [ "nvidia" ];
#   # NVIDIA
#   hardware.nvidia = {
#     modesetting.enable = true;
#     open = false;
#     nvidiaSettings = true;
#     # Experimental. can cause sleep/suspend to fail.
#     # Enable if you have graphical corruption issues or app crashes after waking from sleep.
#     # Thix fixes it by saving entire VRAM memory to /tmp/ instead.
#     powerManagement.enable = false;
#     # Turns off GPU when not in use. Experimental. Only works on modern NVIDIA GPUs (Turing and newer).
#     powerManagement.finegrained = false;
# };
#
#   # OpenGL
#   hardware.opengl = {
#     enable = true;
#     driSupport32Bit = true;
#     extraPackages = with pkgs; [
#       vaapiVdpau # Video Acceleration API
#     ];
#   };

  # STEAM
  # hardware.steam-hardware.enable = true;

  # OTHER GAME SETTINGS
  # programs.gamemode.enable = true;

# Also, add this to  your hardware-configuration.nix
# from Lutris docs
# boot.initrd.kernelModules = [ "nvidia" ];
# boot.blacklistedKernelModules = ["nouveau"];

#  # File systems. use systemdmount instead of fstab
#   fileSystems."/mnt/IronWolf8TB" = {
#   device = "/dev/disk/by-uuid/fb9f1b7b-955a-4f54-89bc-e0bd11e9cbf1";
#   fsType = "ext4";
# };

# # Security
#   # Configure PAM
#   security.pam.services = {
#     login.gnupg = {
#       enable = true;
#       storeOnly = true;
#     };
#     sudo.gnupg = {
#       enable = true;
#       storeOnly = true;
#     };
#   };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
