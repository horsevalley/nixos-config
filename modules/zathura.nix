{ config, lib, pkgs, ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      sandbox = "none";
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      page-padding = 1;
      selection-clipboard = "clipboard";
    };
    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      K = "zoom in";
      J = "zoom out";
      i = "recolor";
      p = "print";
      g = "goto top";
    };
    extraConfig = ''
      map [fullscreen] u scroll half-up
      map [fullscreen] d scroll half-down
      map [fullscreen] D toggle_page_mode
      map [fullscreen] r reload
      map [fullscreen] R rotate
      map [fullscreen] K zoom in
      map [fullscreen] J zoom out
      map [fullscreen] i recolor
      map [fullscreen] p print
      map [fullscreen] g goto top
    '';
  };
}
