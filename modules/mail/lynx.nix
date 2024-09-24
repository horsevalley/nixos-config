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

    # External Programs
    EXTERNAL:http:qutebrowser %s:TRUE
    EXTERNAL:https:qutebrowser %s:TRUE
    EXTERNAL:ftp:qutebrowser %s:TRUE
    EXTERNAL:file:qutebrowser %s:TRUE

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
