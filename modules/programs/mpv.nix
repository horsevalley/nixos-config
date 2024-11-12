{ config, lib, pkgs, ... }:
let
  mpvConf = pkgs.writeText "mpv.conf" ''
    # General settings
    cache=yes
    demuxer-max-bytes=500M
    demuxer-max-back-bytes=100M
    
    # Use yt-dlp as the primary method for handling YouTube URLs
    script-opts=ytdl_hook-ytdl_path=yt-dlp
    
    # Other settings (you can keep or modify these as needed)
    cache-secs=300
    demuxer-readahead-secs=300
    force-seekable=yes
    keep-open=always
  '';
  mpvInputConf = pkgs.writeText "mpv-input.conf" ''
    l seek 5
    h seek -5
    j seek -60
    k seek 60
    S cycle sub
    f cycle fullscreen
    D script-message download_with_yt-dlp
    a cycle-values video-aspect-override "16:9" "4:3" "2.35:1" "-1"  # Cycle through common aspect ratios
    A cycle video-unscaled                                           # Toggle scaling
    Alt+1 set video-zoom 0; set video-pan-x 0; set video-pan-y 0    # Reset zoom and pan
    Alt+= add video-zoom 0.1                                        # Zoom in
    Alt+- add video-zoom -0.1                                       # Zoom out
    Alt+left  add video-pan-x  0.1                                  # Pan left
    Alt+right add video-pan-x -0.1                                  # Pan right
    Alt+up    add video-pan-y  0.1                                  # Pan up
    Alt+down  add video-pan-y -0.1                                  # Pan down
  '';
  mpvModulesLua = pkgs.writeText "modules.lua" ''
    local mpv_config_dir_path = require("mp").command_native({"expand-path", "~~/"})
    function load(relative_path) dofile(mpv_config_dir_path .. "/script_modules/" .. relative_path) end
    load("mpvSockets/mpvSockets.lua")
    mp.set_key_bindings({{"f", "cycle fullscreen"}})
  '';
  mpvSocketsLua = pkgs.writeText "mpvSockets.lua" ''
    -- mpvSockets, one socket per instance, removes socket on exit
    local utils = require 'mp.utils'
    local function get_temp_path()
        local directory_separator = package.config:match("([^\n]*)\n?")
        local example_temp_file_path = os.tmpname()
        
        -- remove generated temp file
        pcall(os.remove, example_temp_file_path)
        
        local separator_idx = example_temp_file_path:reverse():find(directory_separator)
        local temp_path_length = #example_temp_file_path - separator_idx
        
        return example_temp_file_path:sub(1, temp_path_length)
    end
    local tempDir = get_temp_path()
    local function join_paths(...)
        local arg={...}
        local path = ""
        for _, v in ipairs(arg) do
            path = utils.join_path(path, tostring(v))
        end
        return path
    end
    local ppid = utils.getpid()
    os.execute("mkdir " .. join_paths(tempDir, "mpvSockets") .. " 2>/dev/null")
    mp.set_property("options/input-ipc-server", join_paths(tempDir, "mpvSockets", ppid))
    local function shutdown_handler()
        os.remove(join_paths(tempDir, "mpvSockets", ppid))
    end
    mp.register_event("shutdown", shutdown_handler)
  '';
  ytDlpBackgroundScript = pkgs.writeText "yt-dlp_background.lua" ''
    local utils = require 'mp.utils'
    local msg = require 'mp.msg'

    local function is_youtube_url(url)
        return url:match("https?://[%w%.]*youtube%.com/") ~= nil or
               url:match("https?://[%w%.]*youtu%.be/") ~= nil
    end

    local function download_with_yt_dlp()
        local url = mp.get_property("path")
        if not url then
            msg.warn("No URL found")
            return
        end

        if not is_youtube_url(url) then
            msg.warn("Not a YouTube URL, skipping yt-dlp download")
            mp.osd_message("Not a YouTube URL, skipping download")
            return
        end

        local download_dir = os.getenv("HOME") .. "/Videos"
        local command = {
            "yt-dlp",
            "--no-part",
            "-o", download_dir .. "/%(title)s.%(ext)s",
            url
        }

        msg.info("Starting background download with yt-dlp")
        mp.osd_message("Starting background download with yt-dlp")

        utils.subprocess_detached({args = command, cancellable = false})
    end

    mp.add_key_binding("D", "download_with_yt-dlp", download_with_yt_dlp)
    mp.register_script_message("download_with_yt-dlp", download_with_yt_dlp)
  '';
in
{
  environment.systemPackages = [ pkgs.mpv pkgs.yt-dlp ];
  environment.etc = {
    "mpv/mpv.conf".source = mpvConf;
    "mpv/input.conf".source = mpvInputConf;
    "mpv/scripts/modules.lua".source = mpvModulesLua;
    "mpv/script_modules/mpvSockets/mpvSockets.lua".source = mpvSocketsLua;
    "mpv/scripts/yt-dlp_background.lua".source = ytDlpBackgroundScript;
  };
  # system.activationScripts = {
  #   mpvSetup = ''
  #     mkdir -p /home/jonash/.config/mpv/scripts
  #     mkdir -p /home/jonash/.config/mpv/script_modules/mpvSockets
  #     mkdir -p /home/jonash/Videos
  #     ln -sf /etc/mpv/mpv.conf /home/jonash/.config/mpv/mpv.conf
  #     ln -sf /etc/mpv/input.conf /home/jonash/.config/mpv/input.conf
  #     ln -sf /etc/mpv/scripts/modules.lua /home/jonash/.config/mpv/scripts/modules.lua
  #     ln -sf /etc/mpv/script_modules/mpvSockets/mpvSockets.lua /home/jonash/.config/mpv/script_modules/mpvSockets/mpvSockets.lua
  #     ln -sf /etc/mpv/scripts/yt-dlp_background.lua /home/jonash/.config/mpv/scripts/yt-dlp_background.lua
  #     chown -R jonash:users /home/jonash/.config/mpv
  #     chown jonash:users /home/jonash/Videos
  #   '';
  # };
}
