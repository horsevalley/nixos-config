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

in
{
  config = {
    environment.systemPackages = [ pkgs.newsboat ];

    environment.etc."newsboat/config".text = newsboatConfig;
    environment.etc."newsboat/urls".source = ./urls;

    system.activationScripts.newsboat-config = ''
      mkdir -p /home/jonash/.config/newsboat
      cp /etc/newsboat/config /home/jonash/.config/newsboat/config
      cp /etc/newsboat/urls /home/jonash/.config/newsboat/urls
      chown -R jonash:users /home/jonash/.config/newsboat
    '';
  };
}
