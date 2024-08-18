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

}
