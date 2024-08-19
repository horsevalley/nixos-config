{ config, pkgs, ... }:

{
  # System-wide environment variables
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "qutebrowser";
  };


  # Set the custom path for .desktop files
  environment.sessionVariables = {
    XDG_DATA_DIRS = [ 
      "/home/jonash/.local/share"
      "$XDG_DATA_DIRS"
    ];
  };

  # Enable xdg mime
  xdg.mime.enable = true;

  # Set up XDG MIME types
  xdg.mimeTypes = {
    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "image/jpeg" = "nsxiv.desktop";
    "image/png" = "nsxiv.desktop";
    "application/pdf" = "zathura.desktop";
    "text/html" = "qutebrowser.desktop";
  };

}
