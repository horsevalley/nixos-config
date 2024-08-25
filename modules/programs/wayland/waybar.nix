{ config, lib, pkgs, ... }:

let
  mediaplayer = pkgs.writeShellScriptBin "mediaplayer" (builtins.readFile ./mediaplayer.sh);
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };

  environment.systemPackages = with pkgs; [
    waybar
    playerctl
    mpc-cli
    mediaplayer
  ];

  # Override the existing Waybar systemd service
  systemd.user.services.waybar = lib.mkForce {
    description = "Waybar as systemd service";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ pkgs.bash mediaplayer ]; # Ensure mediaplayer is in PATH
    serviceConfig = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      KillMode = "mixed";
    };
  };

  # Add a custom configuration file for Waybar
  environment.etc."xdg/waybar/config".text = builtins.toJSON [{
    layer = "top";
    position = "top";
    height = 30;
    modules-left = [
      "hyprland/workspaces"
      "hyprland/submap"
      "custom/media"
    ];
    modules-center = [
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
      "clock"
    ];
    "hyprland/workspaces" = {
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "";
        "6" = "";
        "7" = "";
        "8" = "";
        "9" = "";
        "10" = "";
        urgent = "";
        focused = "";
        default = "";
      };
      sort-by-number = true;
    };
    "clock" = {
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
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
      exec = "mediaplayer"; # Use the script name directly
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

  # Add a custom style file for Waybar
  environment.etc."xdg/waybar/style.css".source = ./waybar-style.css;

  # Ensure the mediaplayer script is in the system PATH
  environment.systemPackages = [ mediaplayer ];
  environment.sessionVariables = {
    PATH = [ "${mediaplayer}/bin" ];
  };
}
