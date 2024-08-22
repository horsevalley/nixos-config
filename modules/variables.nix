
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
    XDG_CONFIG_HOME = [ 
      "/home/jonash/.config"
      "$XDG_CONFIG_HOME"
    ];
    XDG_DATA_HOME = [ 
      "/home/jonash/.local/share"
      "$XDG_DATA_HOME"
    ];
    XDG_CACHE_HOME = [ 
      "/home/jonash/.cache"
      "$XDG_CACHE_HOME"
    ];
  };

  # Enable xdg mime
  xdg.mime.enable = true;

}
