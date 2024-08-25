{ config, lib, pkgs, ... }:

let
  mediaplayer = pkgs.writeShellScriptBin "mediaplayer" (builtins.readFile ./mediaplayer.sh);
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [
        "hyprland/workspaces"
        "hyprland/submap"
        "custom/media"
      ];
      modules-center = [];
      modules-right = [
        "idle_inhibitor"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "backlight"
        "battery"
        "tray"
        "clock"
      ];
      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
        sort-by-number = true;
        active-only = false;
        all-outputs = true;
      };
      "clock" = {
        tooltip-format = "<big>{:%a %d %b %H:%M}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%a %d %b %H:%M}";
      };
      "cpu" = {
        format = "{usage}% ";
        tooltip = false;
      };
      "memory" = {
        format = "{}% ";
      };
      "temperature" = {
        critical-threshold = 90;
        format = "{temperatureC}°C {icon}";
        format-icons = ["" "" ""];
      };
      "backlight" = {
        format = "{percent}% {icon}";
        format-icons = ["" ""];
      };
      "battery" = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = ["" "" "" "" ""];
      };
      "network" = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      "pulseaudio" = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pulsemixer";
      };
      "custom/media" = {
        format = "{icon} {}";
        return-type = "json";
        max-length = 40;
        format-icons = {
          "youtube-music" = "";
          "ncmpcpp" = "";
          default = "🎜";
        };
        escape = true;
        exec = "${mediaplayer}/bin/mediaplayer";
        interval = 1;
      };
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      "tray" = {
        icon-size = 21;
        spacing = 10;
      };
    }];
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", Roboto, Helvetica, Arial, sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(43, 48, 59, 0.5);
        border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #ffffff;
        border-bottom: 3px solid transparent;
      }

      #workspaces button.active {
        background: lightcoral;
        border-bottom: 3px solid #ffffff;
      }

      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
        box-shadow: inherit;
        border-bottom: 3px solid #ffffff;
      }

      #custom-media {
        background-color: #66cc99;
        color: #2a5c45;
        min-width: 100px;
      }

      #custom-media.custom-spotify {
        background-color: #66cc99;
      }

      #custom-media.custom-vlc {
        background-color: #ffa000;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor {
        padding: 0 10px;
        margin: 0 4px;
        color: #ffffff;
      }

      #clock {
        background-color: #64727D;
      }

      #battery {
        background-color: #ffffff;
        color: #000000;
      }

      #battery.charging {
        color: #ffffff;
        background-color: #26A65B;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #cpu {
        background-color: #2ecc71;
        color: #000000;
      }

      #memory {
        background-color: #9b59b6;
      }

      #backlight {
        background-color: #90b1b1;
      }

      #network {
        background-color: #2980b9;
      }

      #network.disconnected {
        background-color: #f53c3c;
      }

      #pulseaudio {
        background-color: #f1c40f;
        color: #000000;
      }

      #pulseaudio.muted {
        background-color: #90b1b1;
        color: #2a5c45;
      }

      #temperature {
        background-color: #f0932b;
      }

      #temperature.critical {
        background-color: #eb4d4b;
      }

      #tray {
        background-color: #2980b9;
      }

      #idle_inhibitor {
        background-color: #2d3436;
      }

      #idle_inhibitor.activated {
        background-color: #ecf0f1;
        color: #2d3436;
      }
    '';
  };

  environment.systemPackages = with pkgs; [
    waybar
    playerctl
    mpc-cli
    mediaplayer
    pulsemixer
  ];

  # Ensure the mediaplayer script is in the system PATH
  environment.sessionVariables = {
    PATH = [
      "${mediaplayer}/bin"
    ] ++ (lib.optional (config.environment.sessionVariables ? PATH) config.environment.sessionVariables.PATH);
  };
}
