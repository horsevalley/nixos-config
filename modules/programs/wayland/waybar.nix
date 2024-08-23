{ config, pkgs, ... }:

{

  programs.waybar = {
  enable = true;
  systemd.enable = true;
    settings = {
      layer = "bottom";
      height = 30;
      modulesRight = [
        "network"
        "battery"
        "clock"
      ];
      modulesLeft = [
        "workspaces"
      ];

      workspaces = {
        format = "{name}";
        maxLength = 15;
        spacing = 5;
        padding = 10;
        hideIfEmpty = true;
        icons = true;
      };

      network = {
        format = "{ifname}: {rate} ↓ {rate_up} ↑";
        formatConnected = "{ifname}: {rate} ↓ {rate_up} ↑";
        formatDisconnected = "No Network";
        tooltip = true;
      };

      battery = {
        format = "{percentage}% {icon}";
        formatCharging = "{percentage}% {icon} (Charging)";
        formatDischarging = "{percentage}% {icon}";
        formatFull = "Fully Charged";
        tooltip = true;
      };

      clock = {
        format = "%Y-%m-%d %H:%M:%S";
        tooltip = false;
      };

      appearance = {
        background = "#282c34";
        foreground = "#ffffff";
        border = "#4c566a";
        font = "monospace 10";
      };
    };
  };

}
