{ config, pkgs, ... }:

{

  programs.waybar = {
  enable = true;
  systemd.enable = true;
  settings = [{

  "layer": "top",
  "height": 30,
  "modules-right": [
    "network",
    "battery",
    "clock"
  ],
  "modules-left": [
    "workspaces"
  ],
  "workspaces": {
    "format": "{name}",
    "max-length": 15,
    "spacing": 5,
    "padding": 10,
    "tooltip": false,
    "hide-if-empty": true,
    "icons": true
  },
  "network": {
    "format": "{ifname}: {rate} ↓ {rate_up} ↑",
    "format-connected": "{ifname}: {rate} ↓ {rate_up} ↑",
    "format-disconnected": "No Network",
    "tooltip": true
  },
  "battery": {
    "format": "{percentage}% {icon}",
    "format-charging": "{percentage}% {icon} (Charging)",
    "format-discharging": "{percentage}% {icon}",
    "format-full": "Fully Charged",
    "tooltip": true
  },
  "clock": {
    "format": "%Y-%m-%d %H:%M:%S",
    "tooltip": false
  },
  "appearance": {
    "background": "#282c34",
    "foreground": "#ffffff",
    "border": "#4c566a",
    "font": "monospace 10"
  }


  }];
};

}
