{ config, pkgs, lib, ... }:

{

  # Create a custom wrapper for nsxiv with our desired configuration
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nsxiv-custom" ''
      #!/usr/bin/env sh
      export NSXIV_BACKGROUND="#000000"  # Set background color to black
      
      # Create a temporary directory for the key handler script
      TEMP_DIR=$(mktemp -d)
      trap 'rm -rf "$TEMP_DIR"' EXIT

      # Create the key handler script
      cat > "$TEMP_DIR/nsxiv-key-handler" << EOF

      #!/usr/bin/env sh
      while read -r file
      do
        case "$1" in
          # Navigation
          "j"|"Down")     echo "next" ;;        # Next image
          "k"|"Up")       echo "prev" ;;        # Previous image
          "h"|"Left")     echo "scroll_left" ;; # Scroll left
          "l"|"Right")    echo "scroll_right" ;;# Scroll right

          # Zoom
          "="|"+")        echo "zoom_in" ;;     # Zoom in
          "-")            echo "zoom_out" ;;    # Zoom out

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
      EOF

      chmod +x "$TEMP_DIR/nsxiv-key-handler"

      # Run nsxiv with our custom configuration
      ${nsxiv}/bin/nsxiv -a -z 100 -k "$TEMP_DIR/nsxiv-key-handler" "$@"
    '')
  ];

}
