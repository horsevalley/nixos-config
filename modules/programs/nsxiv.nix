{ config, pkgs, lib, ... }:

{
  # Enable nsxiv
  programs.nsxiv = {
    enable = true;

    # Configuration options for nsxiv
    settings = {
      # Set background color to black
      background = "#000000";

      # Vim-like keybindings for image navigation
      keyhandler = pkgs.writeShellScript "nsxiv-keyhandler" ''
        #!usr/bin/env sh
        while read -r file
        do
          case "$1" in
            # Navigation
            "j"|"Down")     echo "next" ;;        # Next image
            "k"|"Up")       echo "prev" ;;        # Previous image
            "h"|"Left")     echo "scroll_left" ;; # Scroll left
            "l"|"Right")    echo "scroll_right" ;;# Scroll right

            # Zoom
            # "="|"+")        echo "zoom_in" ;;     # Zoom in
            # "-")            echo "zoom_out" ;;    # Zoom out
            "K"|"+")        echo "zoom_in" ;;     # Zoom in
            "J")            echo "zoom_out" ;;    # Zoom out

            # Rotation
            "r")            echo "rotate" ;;      # Rotate clockwise
            "R")            echo "rotate_cc" ;;   # Rotate counter-clockwise

            # Flipping
            "f")            echo "flip" ;;        # Flip horizontally
            "F")            echo "flip_v" ;;      # Flip vertically

            # File operations
            "d")            echo "remove" ;;      # Mark for deletion
            "D")            echo "delete" ;;      # Delete marked files

            # Other
            "m")            echo "mark" ;;        # Mark/unmark current image
            "q")            echo "quit" ;;        # Quit nsxiv

            # Add more custom keybindings here
            # "key")         echo "action" ;;
          esac
        done
      '';
    };

    # Additional options
    extraOptions = [
      "-z" "100"  # Set initial zoom level to 100%
      "-a"        # Make nsxiv anti-aliased
    ];
  };

  # You can add more nsxiv-related configurations here if needed
}
