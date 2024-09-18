{ config, pkgs, lib, ... }:

let
  username = "jonash";  # Replace with your actual username
in
{
  environment.systemPackages = [ pkgs.lynx ];

  system.activationScripts.lynxSetup = ''
    # Ensure XDG config directory exists
    mkdir -p /home/${username}/.config/lynx

    # Create lynx config file
    cat > /home/${username}/.config/lynx/lynx.cfg << EOL
    # Basic Settings
    STARTFILE:https://duckduckgo.com/lite
    DEFAULT_INDEX_FILE:https://duckduckgo.com/lite
    HELPFILE:file://localhost/usr/share/doc/lynx/lynx_help/lynx_help_main.html

    # Character Set and Display
    CHARACTER_SET:UTF-8
    ASSUME_CHARSET:UTF-8
    PREFERRED_CHARSET:UTF-8
    ASSUME_LOCAL_CHARSET:UTF-8

    # User Interface
    SHOW_CURSOR:ON
    VI_KEYS_ALWAYS_ON:ON
    KEYPAD_MODE:LINKS_AND_FORM_FIELDS_ARE_NUMBERED
    EMACS_KEYS_ALWAYS_ON:OFF
    DEFAULT_KEYPAD_MODE:NUMBERS_AS_ARROWS
    VERBOSE_IMAGES:ON
    MAKE_LINKS_FOR_ALL_IMAGES:ON

    # Vim-like Navigation
    KEYMAP:j:NEXT_LINE
    KEYMAP:k:PREV_LINE
    KEYMAP:h:PREV_DOC
    KEYMAP:l:NEXT_DOC
    KEYMAP:g:HOME
    KEYMAP:G:END
    KEYMAP:/:WHEREIS
    KEYMAP:n:NEXT
    KEYMAP:N:PREV
    KEYMAP:i:NOCACHE

    # Additional Vim-inspired Keybindings
    KEYMAP:H:HELP
    KEYMAP:u:HISTORY
    KEYMAP:U:GOTO
    KEYMAP:r:RELOAD
    KEYMAP:ZZ:QUIT
    KEYMAP:gg:HOME
    KEYMAP:f:NEXT_PAGE
    KEYMAP:b:PREV_PAGE
    KEYMAP:d:DOWNLOAD
    KEYMAP:o:OPTIONS
    KEYMAP:O:TRACE_TOGGLE

    # Colors
    COLOR:0:black:white
    COLOR:1:blue:white
    COLOR:2:yellow:blue
    COLOR:3:green:white
    COLOR:4:magenta:white
    COLOR:5:blue:white
    COLOR:6:red:white
    COLOR:7:magenta:cyan

    # External Programs
    EXTERNAL:http:firefox %s:TRUE
    EXTERNAL:https:firefox %s:TRUE
    EXTERNAL:ftp:firefox %s:TRUE
    EXTERNAL:file:firefox %s:TRUE

    # Misc
    CASE_SENSITIVE_SEARCHING:OFF
    UNDERLINE_LINKS:ON
    USE_MOUSE:OFF
    VERBOSE_IMAGES:ON
    MAKE_LINKS_FOR_ALL_IMAGES:OFF
    EOL

    # Set correct permissions
    chown -R ${username}:users /home/${username}/.config/lynx
  '';

  # Set the LYNX_CFG environment variable to use the user-specific configuration
  environment.variables = {
    LYNX_CFG = "$HOME/.config/lynx/lynx.cfg";
  };
}
