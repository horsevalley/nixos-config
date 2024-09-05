{ config, lib, pkgs, ... }:

{
  environment.shellAliases = {
    # Verbosity and settings that you pretty much just always are going to want.
    cp = "cp -iv";
    mv = "mv -iv";
    rm = "rm -vI";
    bc = "bc -ql";
    rsync = "rsync -avPh";
    mkd = "mkdir -pv";
    yt = "yt-dlp --embed-metadata -i";
    yta = "yt -x -f bestaudio/best";
    ytt = "yt --skip-download --write-thumbnail";
    ffmpeg = "ffmpeg -hide_banner";

    # Colorize commands when possible.
    ls = "ls -hN --color=auto --group-directories-first";
    la = "ls -AhN --color=auto --group-directories-first";
    ll = "ls -lA --color=auto --group-directories-first";
    eza = "eza -a --group-directories-first";
    lt = "eza --tree --level=2 --long --icons --git";
    grep = "grep --color=auto";
    diff = "diff --color=auto";
    ccat = "highlight --out-format=ansi";
    ip = "ip -color=auto";

    # Abbreviated commands
    ka = "killall";
    g = "git";
    trem = "transmission-remote";
    YT = "youtube-viewer";
    sdn = "shutdown -h now";
    e = "$EDITOR";
    v = "$EDITOR";
    p = "pacman";
    xi = "sudo xbps-install";
    xr = "sudo xbps-remove -R";
    xq = "xbps-query";
    z = "zathura";

    # Directory navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "......" = "cd ../../../../..";

    # Additional aliases
    school = "cd ~/Insync/hestdahl@gmail.com/School/Bachelor\\ Ingeniørfag/Bachelor\\ Ingeniørfag\\ -\\ Bygg && ls -lahN";
    so = "source ~/.config/zsh/.zshrc";
    calc = "speedcrunch";
    sus = "sudo systemctl suspend";
    ym = "youtube-music";
    notion = "notion-app";
    focus = "mpv /home/jonash/Music/Smoothed\\ Brown\\ Noise\\ 8-Hours\\ -\\ Remastered,\\ for\\ Relaxation,\\ Sleep,\\ Studying\\ and\\ Tinnitus.mp4";
    cal = "cal -m -w -3";
    gconfig = "/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME";
    code = "cd ~/code/ && ll || ls -lh";
    b = "blueman-manager";
    s = "speedtest";
    fdv = "cd /home/jonash/Documents/FDV && ls -l";
    pm = "pulsemixer";
    py = "python";
    finance = "cd /home/jonash/Documents/finance";
    ns = "sudo nvidia-settings";
    apps = "cd ~/apps && ls";
    books = "cd ~/Books && ls";
    lw = "librewolf";
    signal = "signal-desktop";
    kamera = "cd ~/Syncthing/pixel6a-kamera/ && ls";
    pi = "echo 'scale=10; 4*a(1)' | bc -l";
    pyvenv = "source ~/python-venv/bin/activate";
    pyvenv_deactivate = "deactivate";
    clock = "tty-clock -c -f '%a %d %b %H:%M'";
    dotfiles = "cd ~/dotfiles-nix && ls";
    sxiv = "nsxiv";
    hst = "history 1 -1 | cut -c 8- | sort | uniq | fzf | tr -d '\\n' | xclip -sel c";
    gpumonitor = "watch -n 2 nvidia-smi";
    bottles = "flatpak run com.usebottles.bottles";
    todo = "bat ~/obsidian/TODO.md";
    newnet = "sudo systemctl restart NetworkManager";
    enword = "sdcv --color '$@' | w3m -graph";
    lukesmith = "cd ~/Videos/Luke\\ Smith/ && ls";
    scim = "sc-im";
    pomodoro = "termdown 1500";
    pv = "pipe-viewer";
    cfs = "vim ~/.local/bin/snippets";
    tmp = "cd /tmp && ls -a";
    cft = "vim ~/.config/tmux/tmux.conf";
    remastered = "cd /home/jonash/code/python/python-developer-bootcamp-tuomas-kivioja/remastered && ls";
    aic = "ascii-image-converter";
    website = "cd ~/website-jonashxyz/jonashxyz/ && ls";
    update_website = "rsync -vrP --delete-after /home/jonash/website-jonashxyz/jonashxyz/public/ root@jonash.xyz:/var/www/jonashxyz/";
    ms = "mailsync";
    kindle = "cd /mnt/kindle/documents/Downloads/Books/ && ls";
    reading = "bat ~/vimwiki/2024.wiki";
    sb = "cd ~/repos/github/obsidian/ && ll";
    lg = "lazygit";
    scripts = "cd ~/dotfiles-nix/scripts/.local/bin/ && ls";
    hss = "hugo server --noHTTPCache";
    nb = "newsboat";
    ga = "git add";
    gP = "git push";
    gp = "git pull";
    gpr = "git pull --rebase";
    gs = "git status";
    gd = "git diff";
    gl = "git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    gc = "git commit";
    gcm = "git commit -m";
    gco = "git checkout";
    gf = "git fetch";
    k = "kubectl";
    kgp = "kubectl get pods";
    fishies = "asciiquarium";
    fp = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
    matrix = "mpv -fs --loop-playlist=inf ~/Videos/screensavers/matrix.webm";
    lastmod = "find . -type f -not -path '*/\\.*' -exec ls -lrt {} +";
    cfq = "v ~/.config/qutebrowser/config.py";
    brightness_reduce = "brightnessctl set 5%";
    brightness_max = "brightnessctl set 100%";
    lzd = "lazydocker";
    wallpapers = "cd ~/repos/github/wallpapers/ && ls";
    ff = "fastfetch";
    cv = "cd ~/repos/github/CV && ls";
    cfk = "vim ~/.config/kitty/kitty.conf";
    nconfig = "sudo nvim /etc/nixos/configuration.nix";
    cfh = "nvim ~/.config/hypr/hyprland.conf";
    youtube = "youtube-tui";
    rofi = "rofi -show drun";
    nixos-config = "cd ~/repos/github/nixos-config/ && la ";
    nconfig-backup = "/home/jonash/dotfiles-nix/scripts/.local/bin/nixos-backup";
    fr = "sudo nixos-rebuild switch --flake ~/repos/github/nixos-config/#$(hostname)";
    podcasts = "cd ~/Videos/podcasts/ && la";
    nfu = "sudo nix flake update";
    cfy = "vim ~/.config/yazi/yazi.toml";
    frd = "sudo nixos-rebuild dry-run --flake ~/repos/github/nixos-config/#$(hostname)";
  };
}
