{ config, pkgs, lib, ... }:

let
  username = "jonash";  # Replace with your actual username
in
{

  # Configure system-wide MIME type associations
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "application/xhtml+xml" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "application/x-bittorrent" = "torrent.desktop";
    "x-scheme-handler/magnet" = "torrent.desktop";
    "image/jpeg" = "nsxiv.desktop";
    "image/bmp" = "nsxiv.desktop";
    "image/gif" = "nsxiv.desktop";
    "image/jpg" = "nsxiv.desktop";
    "image/png" = "nsxiv.desktop";
    "image/tiff" = "nsxiv.desktop";
    "image/x-bmp" = "nsxiv.desktop";
    "image/x-portable-anymap" = "nsxiv.desktop";
    "image/x-portable-bitmap" = "nsxiv.desktop";
    "image/x-portable-graymap" = "nsxiv.desktop";
    "image/x-tga" = "nsxiv.desktop";
    "image/x-xpixmap" = "nsxiv.desktop";
    "image/webp" = "nsxiv.desktop";
    "image/heic" = "nsxiv.desktop";
    "image/svg+xml" = "nsxiv.desktop";
    "image/jp2" = "nsxiv.desktop";
    "image/jxl" = "nsxiv.desktop";
    "image/avif" = "nsxiv.desktop";
    "image/heif" = "nsxiv.desktop";
  };

  # Ensure the user-specific mimeapps.list is created and populated
  system.activationScripts.setupMimeApps = ''
    mkdir -p /home/${username}/.config
    cat > /home/${username}/.config/mimeapps.list << EOL
[Default Applications]
x-scheme-handler/http=org.qutebrowser.qutebrowser.desktop
text/html=org.qutebrowser.qutebrowser.desktop
application/xhtml+xml=org.qutebrowser.qutebrowser.desktop
x-scheme-handler/https=org.qutebrowser.qutebrowser.desktop
application/x-bittorrent=torrent.desktop
x-scheme-handler/magnet=torrent.desktop
image/jpeg=nsxiv.desktop
image/bmp=nsxiv.desktop
image/gif=nsxiv.desktop
image/jpg=nsxiv.desktop
image/png=nsxiv.desktop
image/tiff=nsxiv.desktop
image/x-bmp=nsxiv.desktop
image/x-portable-anymap=nsxiv.desktop
image/x-portable-bitmap=nsxiv.desktop
image/x-portable-graymap=nsxiv.desktop
image/x-tga=nsxiv.desktop
image/x-xpixmap=nsxiv.desktop
image/webp=nsxiv.desktop
image/heic=nsxiv.desktop
image/svg+xml=nsxiv.desktop
image/jp2=nsxiv.desktop
image/jxl=nsxiv.desktop
image/avif=nsxiv.desktop
image/heif=nsxiv.desktop

[Added Associations]
x-scheme-handler/http=org.qutebrowser.qutebrowser.desktop;
text/html=org.qutebrowser.qutebrowser.desktop;
application/xhtml+xml=org.qutebrowser.qutebrowser.desktop;
x-scheme-handler/https=org.qutebrowser.qutebrowser.desktop;
image/bmp=nsxiv.desktop;
image/gif=nsxiv.desktop;
image/jpg=nsxiv.desktop;
image/png=nsxiv.desktop;
image/tiff=nsxiv.desktop;
image/x-bmp=nsxiv.desktop;
image/x-portable-anymap=nsxiv.desktop;
image/x-portable-bitmap=nsxiv.desktop;
image/x-portable-graymap=nsxiv.desktop;
image/x-tga=nsxiv.desktop;
image/x-xpixmap=nsxiv.desktop;
image/webp=nsxiv.desktop;
image/heic=nsxiv.desktop;
image/svg+xml=nsxiv.desktop;
image/jp2=nsxiv.desktop;
image/jxl=nsxiv.desktop;
image/avif=nsxiv.desktop;
image/heif=nsxiv.desktop;
EOL
    chown ${username}:users /home/${username}/.config/mimeapps.list
  '';
}
