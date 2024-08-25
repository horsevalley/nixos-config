{ config, lib, pkgs, ... }:

let
  mediaplayer = pkgs.writeShellScriptBin "mediaplayer" (builtins.readFile ./mediaplayer.sh);
in
{
  # Install Waybar and other required packages
  environment.systemPackages = with pkgs; [
    waybar
    playerctl
    mpc-cli
    mediaplayer
    pulsemixer
  ];

  # Waybar configuration
  environment.etc."xdg/waybar/config".source = pkgs.writeText "waybar-config" (builtins.toJSON [{
    layer = "top";
    position = "top";
    height = 30;
    modules-left = [
      "hyprland/workspaces"
      "custom/media"
    ];
    modules-center = ["clock"];
    modules-right = [
      "pulseaudio"
      "network"
      "cpu"
      "memory"
      "temperature"
      "backlight"
      "battery"
      "tray"
    ];
    "hyprland/workspaces" = {
      format = "{name}";
      on-click = "activate";
      sort-by-number = true;
    };
    "clock" = {
      format = "{:%H:%M}";
      format-alt = "{:%Y-%m-%d}";
    };
    "cpu" = {
      format = "CPU {usage}%";
    };
    "memory" = {
      format = "RAM {}%";
    };
    "temperature" = {
      critical-threshold = 90;
      format = "{temperatureC}°C";
    };
    "backlight" = {
      format = "Light {percent}%";
    };
    "battery" = {
      format = "Bat {capacity}%";
    };
    "network" = {
      format-wifi = "WiFi ({signalStrength}%)";
      format-ethernet = "Eth";
      format-disconnected = "Disconnected";
    };
    "pulseaudio" = {
      format = "Vol {volume}%";
      on-click = "pulsemixer";
    };
    "custom/media" = {
      format = "{}";
      exec = "${mediaplayer}/bin/mediaplayer";
      interval = 1;
    };
    "tray" = {
      icon-size = 21;
      spacing = 10;
    };
  }]);

  # Waybar style
  environment.etc."xdg/waybar/style.css".source = pkgs.writeText "waybar-style" ''
    * {
      border: none;
      border-radius: 0;
      font-family: "JetBrainsMono Nerd Font", sans-serif;
      font-size: 13px;
      min-height: 0;
    }

    window#waybar {
      background: rgba(43, 48, 59, 0.5);
      color: #ffffff;
    }

    #workspaces button {
      padding: 0 5px;
      background: transparent;
      color: #ffffff;
    }

    #workspaces button.active {
      background: lightcoral;
    }

    #clock, #battery, #cpu, #memory, #temperature, #backlight, #network, #pulseaudio, #custom-media, #tray {
      padding: 0 10px;
      margin: 0 5px;
    }

    #clock {
      background-color: #64727D;
    }

    #battery {
      background-color: #ffffff;
      color: black;
    }

    #battery.charging {
      color: white;
      background-color: #26A65B;
    }

    @keyframes blink {
      to {
        background-color: #ffffff;
        color: black;
      }
    }

    #battery.warning:not(.charging) {
      background: #f53c3c;
      color: white;
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }
  '';

  # Add mediaplayer to PATH
  environment.sessionVariables = {
    PATH = [
      "${mediaplayer}/bin"
    ] ++ (lib.optional (config.environment.sessionVariables ? PATH) config.environment.sessionVariables.PATH);
  };
}
