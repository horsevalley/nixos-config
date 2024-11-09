{ config, pkgs, ... }:

let
  username = "jonash"; # Replace with your actual username
in
{
  config = {
    # Enable sound
    sound.enable = true;
    # hardware.pulseaudio.enable = false;

    # PipeWire configuration
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable wireplumber
    services.pipewire.wireplumber.enable = true;

    # Ensure PipeWire is started for the user's session
    systemd.user.services.pipewire.wantedBy = [ "default.target" ];

    # Disable system-wide MPD service
    services.mpd.enable = false;

    # Install audio-related packages
    environment.systemPackages = with pkgs; [
      mpc_cli
      ncmpcpp
      mpd
    ];

    # User-level MPD service
    systemd.user.services.mpd = {
      description = "Music Player Daemon";
      after = [ "network.target" "sound.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon";
        Type = "notify";
        Restart = "always";
        RestartSec = 2;
      };
    };

    # MPD configuration
    environment.etc."mpd/mpd.conf".text = ''
      music_directory "~/Music"
      playlist_directory "~/.config/mpd/playlists"
      db_file "~/.config/mpd/database"
      log_file "~/.config/mpd/log"
      pid_file "~/.config/mpd/pid"
      state_file "~/.config/mpd/state"
      sticker_file "~/.config/mpd/sticker.sql"

      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
      
      audio_output {
        type   "fifo"
        name   "Visualizer feed"
        path   "/tmp/mpd.fifo"
        format "192000:24:2"

      }

      bind_to_address "127.0.0.1"
      port "6600"
      
      auto_update "yes"
      restore_paused "yes"
    '';

# ncmpcpp configuration
    environment.etc."ncmpcpp/config".text = ''
      ncmpcpp_directory = "~/.config/ncmpcpp"
      lyrics_directory = "~/.local/share/lyrics"
      mpd_music_dir = "~/Music"
      message_delay_time = "1"
      
      # Full-width highlighting for current playing song
      current_item_prefix = "$(blue)$r"
      current_item_suffix = "$/r$(end)"
      
      # Format for song list display - removed right-aligned time to allow full highlight
      song_list_format = "{%a - }{%t}|{%f}"
      
      # Current item inactive column settings
      current_item_inactive_column_prefix = "$(blue)$r"
      current_item_inactive_column_suffix = "$/r$(end)"
      
      now_playing_prefix = "$(blue)$r"
      now_playing_suffix = "$/r$(end)"
      
      # Other display settings
      playlist_display_mode = "columns"
      browser_display_mode = "columns"
      progressbar_look = "━━─"
      media_library_primary_tag = "album_artist"
      media_library_albums_split_by_date = "no"
      startup_screen = "playlist"
      display_volume_level = "no"
      ignore_leading_the = "yes"
      external_editor = "nvim"
      use_console_editor = "yes"
      
      # Colors
      colors_enabled = "yes"
      empty_tag_color = "blue"
      header_window_color = "blue"
      volume_color = "blue"
      state_line_color = "blue"
      state_flags_color = "blue"
      main_window_color = "blue"
      color1 = "blue"
      color2 = "blue"
      progressbar_color = "black"
      progressbar_elapsed_color = "blue"
      statusbar_color = "blue"
      statusbar_time_color = "blue"
      player_state_color = "blue"
      alternative_ui_separator_color = "blue"
      window_border_color = "blue"
      active_window_border = "blue"
      
      selected_item_prefix = "$5"
      selected_item_suffix = "$9"
      modified_item_prefix = "$5"
      
      # Column settings - adjusted to ensure full-width highlight
      song_columns_list_format = "(20)[]{a} (50)[]{t} (20)[]{b} (7f)[]{l}"
      
      # Alternative header settings
      alternative_header_first_line_format = "$5{%t}"
      alternative_header_second_line_format = "{$5%a} - {$5%b}"
      
      # Status format
      song_status_format = "{%a - }{%t}|{%f}"
    '';

    environment.etc."ncmpcpp/bindings".text = ''

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

    # Create necessary directories and copy configs
    system.activationScripts.mpd-ncmpcpp-setup = ''
      mkdir -p /home/${username}/.config/mpd/playlists
      mkdir -p /home/${username}/.config/ncmpcpp
      cp /etc/mpd/mpd.conf /home/${username}/.config/mpd/mpd.conf
      cp /etc/ncmpcpp/config /home/${username}/.config/ncmpcpp/config
      cp /etc/ncmpcpp/bindings /home/${username}/.config/ncmpcpp/bindings
      chown -R ${username}:users /home/${username}/.config/mpd
      chown -R ${username}:users /home/${username}/.config/ncmpcpp
      chown -R ${username}:users /home/${username}/Music
    '';
  };
}
