{ config, lib, pkgs, ... }:

let

  urlHandler = pkgs.writeScriptBin "newsboat-url-handler" ''
    #!/usr/bin/env bash
    url="$1"
    
    # Function to open URL in default browser
    open_in_browser() {
      ${pkgs.xdg-utils}/bin/xdg-open "$1"
    }

    # Function to play video in mpv as a detached process
    play_in_mpv() {
      nohup ${pkgs.mpv}/bin/mpv "$1" </dev/null >/dev/null 2>&1 &
    }

    # Check if the URL is a YouTube video
    if echo "$url" | grep -q -E "youtube.com/watch\?v=|youtu.be/"; then
      play_in_mpv "$url"
    else
      # Extract the first YouTube URL from the page and play it with mpv
      video_url=$(${pkgs.curl}/bin/curl -s "$url" | 
                  ${pkgs.gnugrep}/bin/grep -oP 'https?://(?:www\.)?youtu(?:be\.com/watch\?v=|\.be/)[\w-]+' |
                  head -n 1)
      
      if [ -n "$video_url" ]; then
        play_in_mpv "$video_url"
      fi
      
      # Open the original URL in the default browser
      open_in_browser "$url"
    fi
  '';

  newsboatConfig = ''
    # General settings
    auto-reload yes
    text-width 72
    reload-time 120
    download-retries 4
    download-timeout 10

    # Use our custom URL handler
    browser ${urlHandler}/bin/newsboat-url-handler

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

    # AESTHETICS
    color listnormal blue default bold
    color listnormal_unread white default bold
    color listfocus black blue bold
    color listfocus_unread black blue bold
    color info black blue bold
    color article white default bold

    highlight all "---.*---" blue 
    highlight feedlist ".*(0/0))" black
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
  https://www.reddit.com/r/unixporn.rss  "reddit" "unixporn" 
  https://www.reddit.com/r/linux_gaming.rss  "reddit" "unixporn" 
  https://www.reddit.com/r/worldnews.rss  "reddit" "news"
  https://www.reddit.com/r/selfhosted.rss "selfhosted" "networking"
  https://www.reddit.com/r/HomeNetworking.rss  "reddit" "networking"
  https://www.reddit.com/r/Ubiquiti.rss "reddit" "networking" "ubiquiti"
  https://www.reddit.com/r/suckless.rss "reddit" "suckless"
  https://www.reddit.com/r/archlinux.rss "reddit" "linux" "archlinux"
  https://www.reddit.com/r/unixporn.rss "reddit" "linux"
  https://www.reddit.com/r/ChatGPT.rss "reddit" "chatgpt" "tech"

  "------------------------------------PROGRAMMING--------------------------------"

  "---Travis Media---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCGPGirOab9EGy7VH4IwmWVQ "programming" "tech"

  "---Tech With Tim---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC4JX40jDee_tINbkjycV4Sg "programming" "python"

  "---Philomatics---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCmtC7HJIoMQxkvV4gh5dP0Q "programming" "git"

  "---Mischa Van Den Burg---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCDAck-gFPTrgTx_qp59-bQA "programming" "devops" "zettelkasten" "kubernetes" "MischaVanDenBurg"

  "---Tina Huang - Lonely Octopus---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC2UXDak6o7rBm23k3Vv5dww "tech" "programming"

  "---Tony Teaches Tech---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCWPJwoVXJhv0-ucr3pUs1dA "programming"

  "---Dreams of Autonomy---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCEEVcDuBRDiwxfXAgQjLGug "programming" "Linux"

  "---Charm Blog---"
  https://charm.sh/blog/rss.xml

  "---Redhwan Nacef---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCcDX-RWfzJ1YwprkagBXwrg "programming"

  "---rwxrob---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCs2Kaw3Soa63cJq3H0VA7og "programming"

  "---Typecraft---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCo71RUe6DX4w-Vd47rFLXPg "programming"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCppiOhLD5jQgs6m0j9-PYOA "programming" "ricing"

  "---Devaslife---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC7yZ6keOGsvERMp2HaEbbXQ "programming"

  "---Python Simplified - Mariya---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCKQdc0-Targ4nDIAUrlfKiA "programming" "python"

  "---ThePrimeAgen---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCUyeluBRhGPCW4rPe_UvBZQ "theprimeagen"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC8ENHE5xdFSwx71u3fDH5Xw "theprimeagen"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCVk4b-svNJoeytrrlOixebQ "theprimeagen"

  "---Internet Made Coder---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCcJQ96WlEhJ0Ve0SLmU310Q "programming"

  "---Kalle Hallden---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCWr0mx597DnSGLFk1WfvSkQ "programming"

  "---denvaar---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCDY981jZta5C5A6kQXioGUg "vim"

  "---Tom Delalande---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCYuQjtwffrSIzfswH3V24mQ "programming"

  "---Ania Kubow---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC5DNytAJ6_FISueUfzZCVsw "programming"

  "---BASHBUNNI---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC9H0HzpKf5JlazkADWnW1Jw "programming"

  "---lobste.rs---"
  https://lobste.rs/t/programming.rss "programming"
  https://lobste.rs/t/python.rss "programming"

  "---Simon Willison---"
  https://simonwillison.net/atom/everything/ "tech blog"

  "---CipherLogs---"
  https://cipherlogs.com/rss.xml "programming" "vim"

  "-----------------------------ARTIFICIAL INTELLIGENCE------------------------------"

  "---Wes Roth---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCqcbQf6yw5KzRoDDcZ_wBSw "Ai"

  "------------------------------------LINUX-----------------------------------------"

  "---RobertElderSoftware---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCOmCxjmeQrkB5GmCEssbvxg "linux"

  "---NapoleonWils0n---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCriRR_CzOny-akXyk1R-oDQ "linux"

  "---Gotbletu---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCkf4VIqu3Acnfzuk3kRIFwA "linux"

  "---Bugswriter---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCngn7SVujlvskHRvRKc1cTw "linux"
  https://odysee.com/$/rss/@bugswriter:8 "linux"

  "--- Omerxx - Omer Hamerman ---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCYeiozh-4QwuC1sjgCmB92w "linux" "devops" "~omer hamerman - devops toolbox"

  "---Nerd Signals---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC4TFWfCtAuWGAiJFSSjLAQg "linux"

  "---DistroTube---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCVls1GmFKf6WlTraIb_IaJg "linux"

  "---Matt Duggan---"
  https://matduggan.com/rss/ "linux"

  "------------------------------------DEVOPS & CLOUD-----------------------------------"

  "---TechWorld with Nana---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCdngmbVKX1Tgre699-XLlUA "DevOps" "Cloud" "DevOps & Cloud"

  "------------------------------------KUBERNETES-----------------------------------"

  "---The Learning Channel---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC1WB7heW8kkjsBdFWOIOh1g "kubernetes"

  "------------------------------------NETWORKING-----------------------------------"

  https://www.youtube.com/feeds/videos.xml?channel_id=UCJQJ4GjTiq5lmn8czf8oo0Q "networking"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC9x0AN7BWHpCDHSm9NiJFJQ "networking"

  "------------------------------------SECURITY AND PRIVACY-------------------------"

  "---Cosmodium CyberSecurity---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCJC0LxyEnw9yenVQxYanRzw "Cybersecurity" "Hacking"

  "---Tech with Soleyman---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCQJoT6HfpDIc_A75RLWHGuw "security and privacy"

  "---Low Level Learning---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC6biysICWOJ-C3P4Tyeggzg  "security and privacy"

  "---Louis Rossmann---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCl2mFZoRqjw_ELax4Yisf6w  "security and privacy""networking"

  "-----------------------------------TECH BLOGS------------------------------------"

  https://waitbutwhy.com/feed "tech blog"
  https://jonash.xyz/index.xml "tech blog"
  https://mischavandenburg.substack.com/feed "substack" "MischaVanDenBurg"
  https://mischavandenburg.com/index.xml "tech blog" "MischaVanDenBurg" 
  https://zettelkasten.mischavandenburg.net/index.xml "tech blog" "zettelkasten" "MischaVanDenBurg"
  https://omerxx.com/feed.xml "tech blog"
# http://feeds.feedburner.com/tweakers/mixed "tech blog"
  https://roytang.net/all/feed/rss "tech blog"
  https://solar.lowtechmagazine.com/feeds/all-en.atom.xml "tech blog"
# https://bearblog.dev/discover/feed/ "tech blog"
  https://herman.bearblog.dev/feed/ "tech blog"
# https://tiramisu.bearblog.dev/feed/ "tech blog"
# http://feeds2.feedburner.com/TheArtOfManliness "tech blog"
# http://feeds.kottke.org/main "tech blog"
# https://hnrss.org/frontpage "tech blog"
  https://world.hey.com/dhh/feed.atom "tech blog" "DHH"

  "-----------------------------------TECH NEWS-------------------------------------"

  "---Nova Spirit Tech---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCrjKdwxaQMSV_NDywgKXVmw "tech" "tech news"

  "---Hacker News---"
  https://news.ycombinator.com/rss "tech news"

  "---Anastasi in Tech---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCORX3Cl7ByidjEgzSCgv9Yw "tech news"

  "---ArsTechnica---"
  https://feeds.arstechnica.com/arstechnica/technology-lab "tech-lab"
  https://feeds.arstechnica.com/arstechnica/gadgets "gadgets"
  https://feeds.arstechnica.com/arstechnica/tech-policy "tech-policy"
  https://feeds.arstechnica.com/arstechnica/gaming "gaming"
  https://feeds.arstechnica.com/arstechnica/cars "car news"

  "---Jerryrig Everything---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCWFKCr40YwOZQx8FHU_ZqqQ "tech news"

  "---ColdFusion---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC4QZ_LsYcvcq7qOsOhpAX4A "tech news"

  "---SavvyNik---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC3yaWWA9FF9OBog5U9ml68A "tech news"

  "---MKBHD - Marques Brownlee---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCBJycsmduvYEL83R_U4JriQ "tech news"

  "---Unbox Therapy---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCsTcErHg8oDvUnTzoqsYeNw "tech news"

  "---Freethink---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UConJDkGk921yT9hISzFqpzw "tech news"

  "--- Raspberry Pi Spy---"
  http://www.raspberrypi-spy.co.uk/feed/ "raspberry pi"

  "------------------------------------PODCAST------------------------------------"

  "---JustChattingPod with Mizkif---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCs9WELCg4E2eJXf8yUKimrQ "podcast"

  "---HubermanLab - Dr. Andrew Huberman---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC2D2CMWXMOVWx7giW1n3LIg "science" "podcast"

  "---The Daily Stoic---"
  https://rss.art19.com/the-daily-stoic "meditation" "stoicism" "podcast"

  "---Preacher Lawson---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCHqfteK571ZYNhK_CktN9GQ "podcast"

  "---Lex Fridman---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCSHZKyawb77ixDdsGog4iWA "podcast"

  "---Joe Rogan Experience---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCzQUP1qoWDoEbmsQxvdjxgQ "podcast"

  "---Jocko Willink---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCkqcY4CAuBFNFho6JgygCnA "podcast"

  "---Tech over tea, with Brodie Robertson---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCBq5p-xOla8xhnrbhu8AIAg "podcast"

  "---In Good Company---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCRhQsN8AVIfZuBNeRV1A37w "podcast"

  "---Wolfgang Wee---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCUy3Qp2OBFoC3E_HMLpjZJA "podcast"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCaAf_gIA-BVamaLfpTwyRAQ "podcast"

  "---Rich Roll---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCpjlh0e319ksmoOD7bQFSiw "podcast"

  "-----------------------------------ASTRO PHYSICS NEWS-------------------------"

  "---Anton Petrov---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCciQ8wFcVoIIMi-lfu8-cjQ "astro physics"

  "-----------------------------------SCIENCE------------------------------------"

  "---Theories of Everything with Curt Jaimungal---" "science"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCdWIQh9DGG6uhJk8eyIFl1w

  "---Nature---"
  https://www.nature.com/nature.rss "science"

  "---Norwegian SciTech News---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UClLoynAOMR3j2oz20hBg6YQ "science"

  "-----------------------------------WORLD NEWS---------------------------------"

  "---BBC World News---"
  https://feeds.bbci.co.uk/news/rss.xml "news"

  "---The Young Turks---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC1yBKRuGpC1tSM73A0ZjYjQ "news"


  "------------------------------PRODUCTIVITY, LEARNING AND SELF-IMPROVEMENT-----------------------"

  "---Morganeua---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCVCaYGoX8UXU7N7v5KdvkiQ "productivity" "zettelkasten"

  "---Nicolas Cole---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCeoMQWq1-dAPave3ythD8MQ "productivity" "self-improvement" "learning"

  "---Clark Kegley---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC-dmJ79518WlKMbsu50eMTQ "productivity" "self-improvement" "learning"

  "---State of Mind---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCuD-OWq0lLKLGkuWuNs35sA "productivity" "self-improvement" "learning"

  "---FromSergio---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCIDJH27tBTlA7jjMI5wnibA "productivity" "self-improvement" "learning"
  "---SpoonFedStudy---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC1Co9XZd52hiVrePGZ8qfoQ "productivity" "self-improvement" "learning"
  "---Bryan Jenks---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCfhSB16X9MXhzSFe_H7XbHg "productivity" "self-improvement" "learning"
  "---Ryder Carroll---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCt3B6rUXb__X2eMyY7jzgIg "productivity" "self-improvement" "learning"
  "---Tiago Forte---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCmvYCRYPDlzSHVNCI_ViJDQ "productivity" "self-improvement" "learning"
  "---Ali Abdaal---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCoOae5nYA7VqaXzerajD0lg "productivity" "self-improvement" "learning"
  "---Tim Ferriss---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCznv7Vf9nBdJYvBagFdAHWw "productivity" "self-improvement" "learning"
  "---CyanVoxel---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCcWZY8dxd4HhlH5vY_Luzgw "productivity" "self-improvement" "learning"

  "---------------------TRADING, INVESTMENT AND ENTREPRENEURSHIP-----------------"

  "---Starter Story---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UChhw6DlKKTQ9mYSpTfXUYqA "trading, investing, entrepreneurship"

  "---Sasha Yanshin---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC1pLUC7lcKkGYhWgj4XvUsw "trading, investing, entrepreneurship"

  "---Peachy Investor---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCr9PVIuy5OEsu8QxqQ5AaVg "trading, investing, entrepreneurship"

  "---DTOptions - Derek Taylor/DistroTube---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCqyrm14zcbZw6pdQeHXPF8w "trading, investing, entrepreneurship"

  "------------------------------------ARCHITECTURE------------------------------"

  "---Architectural Digest---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC0k238zFx-Z8xFH0sxCrPJg "architecture"

  "---The Luxury Home Show---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCLYrUmw0L_bjFeQCvWuiijg "architecture"

  "---30x40 Design Workshop---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCoc2ZM2cYas4DijNdaEJXUA "architecture"

  "---iPad for Architecure---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC0VTAakEbOe_3HUlcKUf39Q "architecture"

  "------------------------------------CULTURE--------------------------------------"

  "---The New Criterion---"
  https://newcriterion.com/xml/Latest.cfm "culture"
  https://newcriterion.com/xml/lastissue.cfm "culture"

  "----------------------------------MEDITATION AND STOICISM------------------------"


  "------------------------------------TRAVEL---------------------------------------"

  "---Mav (Mavrik Joos) ---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCL_BZpt0J9Kqwy6YPWr30ow "travel"

  "---Kasper Høglund---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC8uIbm_0rUM7SyylPpb2GEg "travel"

  "---Eva Zu Beck---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCDTINI9skkeZNY2ZXnBqIkQ "travel"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCvujjwuXGv4mVHoDNZkvkqQ "~Eva Unplugged"

  "---Simon Wilson---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCQCrKxBj5Id79syQEsY2Qxg "travel"

  "---Harald Baldr---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCKr68ZJ4vv6VloNdnS2hjhA "travel"

  "---Bald n Bankrupt---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCxDZs_ltFFvn0FDHT6kmoXA "travel"

  "---Regretlyss---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCP90UDuBDk0wmekh5wahm9w "travel"

  "---Sabbatical---"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCib80j_q5o_C5XsCA9YsAFg "travel"

  "------------------------------------MMA---------------------------------------"
  https://www.youtube.com/feeds/videos.xml?channel_id=UCvgfXK4nTYKudb0rFR6noLA "MMA" "UFC"
  https://www.youtube.com/feeds/videos.xml?channel_id=UC4f1JueVgo5t9HSmobCRPug "MMA" "SBN"

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
