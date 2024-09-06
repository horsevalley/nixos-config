{ config, lib, pkgs, ... }:

let
  kittyConfig = pkgs.writeText "kitty.conf" ''
    # General settings
    confirm_os_window_close 0
    font_family Monospace
    font_size 14
    bold_font auto
    italic_font auto
    bold_italic_font auto
    enable_ligatures yes
    padding_width 5
    padding_height 5
    background_opacity 1.0
    dynamic_background_opacity yes
    scrollback_lines 10000
    tab_bar_edge bottom
    tab_bar_style powerline
    window_title_format {title} - kitty
    detect_urls yes
    mouse_hide_wait 3.0
    mouse_wheel_scroll_multiplier 3.0
    copy_on_select yes
    sync_to_clipboard yes
    enable_audio_bell no
    enable_visual_bell no
    visual_bell_color #ff0000
    bell_border_color #F9E2AF
    draw_minimal_borders smart
    enable_smooth_scrolling yes
    update_title yes
    layout tabbed

    # Theme settings
    foreground #CDD6F4
    background #1E1E2E
    selection_foreground #1E1E2E
    selection_background #F5E0DC
    cursor #F5E0DC
    cursor_text_color #1E1E2E
    url_color #F5E0DC
    active_border_color #B4BEFE
    inactive_border_color #6C7086
    active_tab_foreground #11111B
    active_tab_background #CBA6F7
    inactive_tab_foreground #CDD6F4
    inactive_tab_background #181825
    tab_bar_background #11111B
    mark1_foreground #1E1E2E
    mark1_background #B4BEFE
    mark2_foreground #1E1E2E
    mark2_background #CBA6F7
    mark3_foreground #1E1E2E
    mark3_background #74C7EC

    # Colors
    color0 #45475A
    color8 #585B70
    color1 #F38BA8
    color9 #F38BA8
    color2 #A6E3A1
    color10 #A6E3A1
    color3 #F9E2AF
    color11 #F9E2AF
    color4 #89B4FA
    color12 #89B4FA
    color5 #F5C2E7
    color13 #F5C2E7
    color6 #94E2D5
    color14 #94E2D5
    color7 #BAC2DE
    color15 #A6ADC8

    # Keybindings
    map ctrl+shift+t new_tab
    map f move_forward_char
    map b move_backward_char
    map e move_forward_word
    map ge move_backward_word
    map gg move_to_start_of_screen
    map G move_to_end_of_screen
    map h move_backward_char
    map j move_forward_line
    map k move_backward_line
    map l move_forward_char
    map w move_forward_word
    map W move_forward_word
    map B move_backward_word
    map E move_forward_word
    map 0 move_to_start_of_line
    map $ move_to_end_of_line
    map ctrl+u scroll_up 
    map ctrl+d scroll_down 
    map ctrl+b scroll_page_up
    map ctrl+f scroll_page_down
    map alt+c copy_to_clipboard
    map alt+v paste_from_clipboard
    map alt+shift+j decrease_font_size
    map alt+shift+k increase_font_size
    unmap ctrl+shift+r
    map ctrl+shift+r nop
    map alt+a set_background_opacity +0.1
    map alt+s set_background_opacity -0.1

    # Font size increment
    font_size_increment 0.10

    # OS specific settings
    wayland_titlebar_color system
    macos_titlebar_color system
  '';
in
{
  environment.systemPackages = [ pkgs.kitty ];

  environment.etc."xdg/kitty/kitty.conf".source = kittyConfig;

  system.activationScripts = {
    kittyConfig = ''
      mkdir -p /etc/xdg/kitty
      ln -sf ${kittyConfig} /etc/xdg/kitty/kitty.conf
    '';
  };
}
