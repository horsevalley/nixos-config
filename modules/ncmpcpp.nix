{ config, lib, pkgs, ... }:

let
  ncmpcppBindings = ''
    def_key "+"
        show_clock
    def_key "="
        volume_up
    def_key "j"
        scroll_down
    def_key "k"
        scroll_up
    def_key "ctrl-u"
        page_up
    def_key "ctrl-d"
        page_down
    def_key "u"
        page_up
    def_key "d"
        page_down
    def_key "h"
        previous_column
    def_key "l"
        next_column
    def_key "."
        show_lyrics
    def_key "n"
        next_found_item
    def_key "N"
        previous_found_item
    def_key "J"
        move_sort_order_down
    def_key "K"
        move_sort_order_up
    def_key "h"
      jump_to_parent_directory
    def_key "l"
      enter_directory
    def_key "l"
      run_action
    def_key "l"
      play_item
    def_key "m"
      show_media_library
    def_key "m"
      toggle_media_library_columns_mode
    def_key "t"
      show_tag_editor
    def_key "v"
      show_visualizer
    def_key "G"
      move_end
    def_key "g"
      move_home
    def_key "U"
      update_database
    def_key "s"
      reset_search_engine
    def_key "s"
      show_search_engine
    def_key "f"
      show_browser
    def_key "f"
      change_browse_mode
    def_key "x"
      delete_playlist_items
    def_key "P"
      show_playlist
  '';

  ncmpcppConfig = ''
    ncmpcpp_directory = "~/.config/ncmpcpp"
    lyrics_directory = "~/.local/share/lyrics"
    mpd_music_dir = "~/Music"
    message_delay_time = "1"
    song_list_format = {$4%a - }{%t}|{$8%f$9}$R{$3(%l)$9}
    song_status_format = $b{{$8"%t"}} $3by {$4%a{ $3in $7%b{ (%y)}} $3}|{$8%f}
    song_library_format = {%n - }{%t}|{%f}
    alternative_header_first_line_format = $b$1$aqqu$/a$9 {%t}|{%f} $1$atqq$/a$9$/b
    alternative_header_second_line_format = {{$4$b%a$/b$9}{ - $7%b$9}{ ($4%y$9)}}|{%D}
    current_item_prefix = $(cyan)$r$b
    current_item_suffix = $/r$(end)$/b
    current_item_inactive_column_prefix = $(magenta)$r
    current_item_inactive_column_suffix = $/r$(end)
    playlist_display_mode = columns
    browser_display_mode = columns
    progressbar_look = ->
    media_library_primary_tag = album_artist
    media_library_albums_split_by_date = no
    startup_screen = "media_library"
    display_volume_level = no
    ignore_leading_the = yes
    external_editor = nvim
    use_console_editor = yes
    empty_tag_color = magenta
    main_window_color = white
    progressbar_color = black:b
    progressbar_elapsed_color = blue:b
    statusbar_color = red
    statusbar_time_color = cyan:b
  '';

in
{
  config = {
    environment.systemPackages = [ pkgs.ncmpcpp ];

    environment.etc."ncmpcpp/bindings".text = ncmpcppBindings;
    environment.etc."ncmpcpp/config".text = ncmpcppConfig;

    system.activationScripts.ncmpcpp-config = ''
      mkdir -p /home/jonash/.config/ncmpcpp
      cp /etc/ncmpcpp/bindings /home/jonash/.config/ncmpcpp/bindings
      cp /etc/ncmpcpp/config /home/jonash/.config/ncmpcpp/config
      chown -R jonash:users /home/jonash/.config/ncmpcpp
    '';
  };
}
