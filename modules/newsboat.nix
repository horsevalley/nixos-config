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

    # Colors and highlighting
    color listnormal cyan default
    color listfocus black yellow standout bold
    color listnormal_unread blue default
    color listfocus_unread yellow default bold
    color info red black bold
    color article white default bold

    highlight all "---.*---" yellow
    highlight feedlist ".*(0/0))" black
    highlight article "(^Feed:.*|^Title:.*|^Author:.*)" cyan default bold
    highlight article "(^Link:.*|^Date:.*)" default default
    highlight article "https?://[^ ]+" green default
    highlight article "^(Title):.*$" blue default
    highlight article "\\[[0-9][0-9]*\\]" magenta default bold
    highlight article "\\[image\\ [0-9]+\\]" green default bold
    highlight article "\\[embedded flash: [0-9][0-9]*\\]" green default bold
    highlight article ":.*\\(link\\)$" cyan default
    highlight article ":.*\\(image\\)$" blue default
    highlight article ":.*\\(embedded flash\\)$" magenta default
  '';

  newsboatUrls = ''
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
