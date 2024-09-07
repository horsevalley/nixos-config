{ config, lib, pkgs, ... }:

let
  newsboatConfig = ''
    #show-read-feeds no
    auto-reload yes
    external-url-viewer "urlscan -dc -r 'linkhandler {}'"
    text-width 72
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
    browser linkhandler
    macro , open-in-browser
    macro t set browser "qndl" ; open-in-browser ; set browser linkhandler
    macro a set browser "tsp yt-dlp --embed-metadata -xic -f bestaudio/best --restrict-filenames" ; open-in-browser ; set browser linkhandler
    macro v set browser "setsid -f mpv" ; open-in-browser ; set browser linkhandler
    macro w set browser "lynx" ; open-in-browser ; set browser linkhandler
    macro d set browser "dmenuhandler" ; open-in-browser ; set browser linkhandler
    macro c set browser "echo %u | xclip -r -sel c" ; open-in-browser ; set browser linkhandler
    macro C set browser "youtube-viewer --comments=%u" ; open-in-browser ; set browser linkhandler
    macro p set browser "peertubetorrent %u 480" ; open-in-browser ; set browser linkhandler
    macro P set browser "peertubetorrent %u 1080" ; open-in-browser ; set browser linkhandler
    # AESTHETICS
    color listnormal blue default bold
    color listnormal_unread white default bold
    color listfocus white blue bold
    color listfocus_unread white blue bold
    color info white blue bold
    color article white default bold
    highlight all "---.*---" blue 
    highlight feedlist ''.*\(0/0\)'' black
    highlight article "(^Feed:.*|^Title:.*|^Author:.*)" blue default bold 
    highlight article "(^Link:.*|^Date:.*)" blue default bold
    highlight article "https?://[^ ]+" white default bold
    highlight article "^(Title):.*$" blue default bold
    highlight article "\\[[0-9][0-9]*\\]" magenta default bold
    highlight article "\\[image\\ [0-9]+\\]" blue default bold
    highlight article "\\[embedded flash: [0-9][0-9]*\\]" blue default bold
    highlight article ":.*\\(link\\)$" white default bold
    highlight article ":.*\\(image\\)$" white default bold
    highlight article ":.*\\(embedded flash\\)$" magenta default
  '';

  newsboatUrls = ''
    "-----------------------------------LUKE SMITH-----------------------------------"

    "---Luke Smith---"
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

    "---Reddit---"
    https://www.reddit.com/r/worldnews.rss  "reddit" "news"
    https://www.reddit.com/r/selfhosted.rss "selfhosted" "networking"
    https://www.reddit.com/r/HomeNetworking.rss  "reddit" "networking"
    https://www.reddit.com/r/Ubiquiti.rss "reddit" "networking" "ubiquiti"
    https://www.reddit.com/r/suckless.rss "reddit" "suckless"
    https://www.reddit.com/r/archlinux.rss "reddit" "linux" "archlinux"
    https://www.reddit.com/r/unixporn.rss "reddit" "linux"
    https://www.reddit.com/r/ChatGPT.rss "reddit" "chatgpt" "tech"

    # ... [Rest of your URLs]

    "--------------------------COPY YOUTUBE CHANNEL ID------------------------------"

    "How to copy a YouTube channel_id:"
    "1. Go to the About page"
    "2. Share Channel -> copy channel id"
    "3. https://www.youtube.com/feeds/videos.xml?channel_id=[insert channel id here, w/o brackets]"

    "-------------------------------------------------------------------------------"
  '';

in
{
  config = {
    environment.systemPackages = [ pkgs.newsboat ];

    system.activationScripts = {
      newsboat-config = {
        text = ''
          mkdir -p /home/jonash/.config/newsboat
          echo "${newsboatConfig}" > /home/jonash/.config/newsboat/config
          echo "${newsboatUrls}" > /home/jonash/.config/newsboat/urls
          chown -R jonash:users /home/jonash/.config/newsboat
        '';
        deps = [];
      };
    };
  };
}
