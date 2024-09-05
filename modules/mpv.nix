{ config, lib, pkgs, ... }:

let
  mpvInputConf = pkgs.writeText "mpv-input.conf" ''
    l seek 5
    h seek -5
    j seek -60
    k seek 60
    S cycle sub
    f cycle fullscreen
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

in
{
  environment.systemPackages = [ pkgs.mpv ];

  environment.etc = {
    "mpv/input.conf".source = mpvInputConf;
    "mpv/scripts/modules.lua".source = mpvModulesLua;
    "mpv/script_modules/mpvSockets/mpvSockets.lua".source = mpvSocketsLua;
  };

  system.activationScripts = {
    mpvSetup = ''
      mkdir -p /home/jonash/.config/mpv/scripts
      mkdir -p /home/jonash/.config/mpv/script_modules/mpvSockets
      ln -sf /etc/mpv/input.conf /home/jonash/.config/mpv/input.conf
      ln -sf /etc/mpv/scripts/modules.lua /home/jonash/.config/mpv/scripts/modules.lua
      ln -sf /etc/mpv/script_modules/mpvSockets/mpvSockets.lua /home/jonash/.config/mpv/script_modules/mpvSockets/mpvSockets.lua
      chown -R jonash:users /home/jonash/.config/mpv
    '';
  };
}
