{ config, lib, pkgs, ... }:

let
  newsboatConfig = ''
    # General settings
    auto-reload yes
    reload-time 120
    download-retries 4
    download-timeout 10

    # Keybindings
    bind-key j down
    bind-key k up
    bind-key j next articlelist
    bind-key k prev articlelist
    bind-key J next-feed articlelist
    bind-key K prev-feed articlelist
    bind-key G end
    bind-key g home
    bind-key d pagedown
    bind-key u pageup
    bind-key l open
    bind-key h quit
    bind-key a toggle-article-read
    bind-key n next-unread
    bind-key N prev-unread
    bind-key D pb-download
    bind-key U show-urls
    bind-key x pb-delete

    # Catppuccin Mocha color scheme
    color background default default
    color listnormal default default
    color listnormal_unread color10 default
    color listfocus color15 color8
    color listfocus_unread color15 color8 bold
    color info color13 color8
    color article default default

    # Highlights
    highlight article "^(Feed|Link):.*$" color14 default bold
    highlight article "^(Title|Date|Author):.*$" color14 default bold
    highlight article "https?://[^ ]+" color11 default underline
    highlight article "\\[[0-9]+\\]" color14 default bold
    highlight article "\\[image\\ [0-9]+\\]" color14 default bold
    highlight feedlist "^─.*$" color14 default bold

    # Other custom settings
    text-width 80
    
    # You can add more custom settings here
  '';

  newsboatUrls = ''
    # Your existing URLs here
    "-----------------------------------LUKE SMITH-----------------------------------"
    https://lukesmith.xyz/rss.xml "tech blog"
    https://www.youtube.com/feeds/videos.xml?channel_id=UC2eYFnH61tmytImy1mTYvhA "~Luke Smith (YouTube)"
    https://lindypress.net/rss
    https://notrelated.xyz/rss "podcast"
    https://landchad.net/rss.xml
    https://based.cooking/index.xml "food"
    https://artixlinux.org/feed.php "tech"
    https://www.archlinux.org/feeds/news/ "tech"
    https://github.com/LukeSmithxyz/voidrice/commits/master.atom "~LARBS dotfiles"

    "-----------------------------------REDDIT-------------------------------------"
    https://www.reddit.com/r/worldnews.rss  "reddit" "news"
    https://www.reddit.com/r/selfhosted.rss "selfhosted" "networking"
    https://www.reddit.com/r/HomeNetworking.rss  "reddit" "networking"
    https://www.reddit.com/r/Ubiquiti.rss "reddit" "networking" "ubiquiti"
    https://www.reddit.com/r/suckless.rss "reddit" "suckless"
    https://www.reddit.com/r/archlinux.rss "reddit" "linux" "archlinux"
    https://www.reddit.com/r/unixporn.rss "reddit" "linux"
    https://www.reddit.com/r/ChatGPT.rss "reddit" "chatgpt" "tech"

    # ... (rest of your URLs)
  '';

in
{
  config = {
    environment.systemPackages = [ pkgs.newsboat ];

    environment.etc."newsboat/config".text = newsboatConfig;
    environment.etc."newsboat/urls".text = newsboatUrls;

    system.activationScripts.newsboat-config = ''
      mkdir -p /home/jonash/.config/newsboat
      cp /etc/newsboat/config /home/jonash/.config/newsboat/config
      cp /etc/newsboat/urls /home/jonash/.config/newsboat/urls
      chown -R jonash:users /home/jonash/.config/newsboat
    '';
  };
}
