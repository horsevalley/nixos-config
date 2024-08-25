{ config, lib, pkgs, ... }:

let
  mediaplayer = pkgs.writeShellScriptBin "mediaplayer" (builtins.readFile ./mediaplayer.sh);
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./waybar-style.css;

    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [
        "hyprland/workspaces"
        "hyprland/submap"
        "custom/media"
      ];
      modules-center = [
        "clock"
      ];
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
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          urgent = "";
          focused = "";
          default = "";
        };
      };

      "clock" = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%a %d %b %H:M}";
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
          "default" = "🎜";
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
  };

  # Optional: If you want to ensure Waybar starts with your Hyprland session
  # systemd.user.services.waybar = {
  #   description = "Waybar";
  #   wantedBy = [ "graphical-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.waybar}/bin/waybar";
  #     ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
  #     Restart = "on-failure";
  #     KillMode = "mixed";
  #   };
  # };
}
