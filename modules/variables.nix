
{ config, pkgs, ... }:

{
  # System-wide environment variables
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "qutebrowser";
    XDG_DEFAULT_PDF_VIEWER = "zathura";
    XDG_DEFAULT_IMAGE_VIEWER = "nsxiv";
    XDG_DEFAULT_VIDEO_PLAYER = "mpv";
    XDG_DEFAULT_BROWSER = "qutebrowser";

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

}
