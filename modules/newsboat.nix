{ config, lib, pkgs, ... }:

let
  newsboatConfig = ''
    # Your existing newsboat config here
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

    "------------------------------------PROGRAMMING--------------------------------"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCGPGirOab9EGy7VH4IwmWVQ "programming" "tech"
    https://www.youtube.com/feeds/videos.xml?channel_id=UC4JX40jDee_tINbkjycV4Sg "programming" "python"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCmtC7HJIoMQxkvV4gh5dP0Q "programming" "git"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCDAck-gFPTrgTx_qp59-bQA "programming" "devops" "zettelkasten" "kubernetes" "MischaVanDenBurg"
    https://www.youtube.com/feeds/videos.xml?channel_id=UC2UXDak6o7rBm23k3Vv5dww "tech" "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCWPJwoVXJhv0-ucr3pUs1dA "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCEEVXcDuBRDiwxfXAgQjLGug "programming" "Linux"
    https://charm.sh/blog/rss.xml
    https://www.youtube.com/feeds/videos.xml?channel_id=UCcDX-RWfzJ1YwprkagBXwrg "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCs2Kaw3Soa63cJq3H0VA7og "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCo71RUe6DX4w-Vd47rFLXPg "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCppiOhLD5jQgs6m0j9-PYOA "programming" "ricing"
    https://www.youtube.com/feeds/videos.xml?channel_id=UC7yZ6keOGsvERMp2HaEbbXQ "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCKQdc0-Targ4nDIAUrlfKiA "programming" "python"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCUyeluBRhGPCW4rPe_UvBZQ "theprimeagen"
    https://www.youtube.com/feeds/videos.xml?channel_id=UC8ENHE5xdFSwx71u3fDH5Xw "theprimeagen"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCVk4b-svNJoeytrrlOixebQ "theprimeagen"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCcJQ96WlEhJ0Ve0SLmU310Q "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCWr0mx597DnSGLFk1WfvSkQ "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCDY981jZta5C5A6kQXioGUg "vim"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCYuQjtwffrSIzfswH3V24mQ "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UC5DNytAJ6_FISueUfzZCVsw "programming"
    https://www.youtube.com/feeds/videos.xml?channel_id=UC9H0HzpKf5JlazkADWnW1Jw "programming"
    https://lobste.rs/t/programming.rss "programming"
    https://lobste.rs/t/python.rss "programming"
    https://simonwillison.net/atom/everything/ "tech blog"
    https://cipherlogs.com/rss.xml "programming" "vim"

    # ... Add all your other URLs here ...

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
