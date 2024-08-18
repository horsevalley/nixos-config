{ config, pkgs, ... }:

{
  # System-wide environment variables
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "qutebrowser";
  };

  xdg.mime.enable = true;

  # Set the custom path for .desktop files
  environment.sessionVariables = {
    XDG_DATA_DIRS = [ 
      "/home/jonash/.local/share"
      "$XDG_DATA_DIRS"
    ];
  };

}
