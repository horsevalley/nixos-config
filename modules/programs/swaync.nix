{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.swaync;

  configFile = pkgs.writeText "swaync-config.json" (builtins.toJSON cfg.settings);
  styleFile = pkgs.writeText "swaync-style.css" cfg.style;

  debugScript = pkgs.writeShellScript "swaync-debug" ''
    echo "SwayNC Debug Information" > /tmp/swaync_debug.log
    echo "-------------------------" >> /tmp/swaync_debug.log
    echo "Date: $(date)" >> /tmp/swaync_debug.log
    echo "User: $USER" >> /tmp/swaync_debug.log
    echo "Home: $HOME" >> /tmp/swaync_debug.log
    echo "XDG_CONFIG_HOME: $XDG_CONFIG_HOME" >> /tmp/swaync_debug.log
    echo "-------------------------" >> /tmp/swaync_debug.log
    echo "Checking SwayNC configuration:" >> /tmp/swaync_debug.log
    if [ -d "$HOME/.config/swaync" ]; then
      echo "~/.config/swaync directory exists" >> /tmp/swaync_debug.log
      ls -l "$HOME/.config/swaync" >> /tmp/swaync_debug.log
    else
      echo "~/.config/swaync directory does not exist" >> /tmp/swaync_debug.log
    fi
    echo "-------------------------" >> /tmp/swaync_debug.log
    echo "Checking /etc/swaync:" >> /tmp/swaync_debug.log
    if [ -d "/etc/swaync" ]; then
      echo "/etc/swaync directory exists" >> /tmp/swaync_debug.log
      ls -l /etc/swaync >> /tmp/swaync_debug.log
    else
      echo "/etc/swaync directory does not exist" >> /tmp/swaync_debug.log
    fi
    echo "-------------------------" >> /tmp/swaync_debug.log
    echo "SwayNC service status:" >> /tmp/swaync_debug.log
    systemctl --user status swaync >> /tmp/swaync_debug.log 2>&1
    echo "-------------------------" >> /tmp/swaync_debug.log
    echo "SwayNC logs:" >> /tmp/swaync_debug.log
    journalctl --user -u swaync -n 50 >> /tmp/swaync_debug.log 2>&1
  '';
in
{
  options.programs.swaync = {
    enable = mkEnableOption "SwayNC notification daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.swaynotificationcenter;
      defaultText = literalExpression "pkgs.swaynotificationcenter";
      description = "The SwayNC package to use.";
    };

    settings = mkOption {
      type = types.attrs;
      default = {
        "$schema" = "/etc/xdg/swaync/configSchema.json";
        positionX = "right";
        positionY = "top";
        control-center-margin-top = 0;
        control-center-margin-bottom = 0;
        control-center-margin-right = 0;
        control-center-margin-left = 0;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        timeout = 10;
        timeout-low = 5;
        timeout-critical = 0;
        fit-to-screen = true;
        control-center-width = 500;
        control-center-height = 600;
        notification-window-width = 500;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = false;
        hide-on-action = true;
        script-fail-notify = true;
        widgets = [
          "title"
          "dnd"
          "notifications"
          "mpris"
          "volume"
        ];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear All";
          };
          dnd = {
            text = "Do Not Disturb";
          };
          mpris = {
            image-size = 96;
            image-radius = 12;
          };
        };
      };
      description = "SwayNC configuration options.";
    };

    style = mkOption {
      type = types.lines;
      default = ''
        * {
          all: unset;
          font-family: "DejaVu Sans", sans-serif;
        }

        /* Catppuccin Mocha colors */
        @define-color base   #1e1e2e;
        @define-color mantle #181825;
        @define-color crust  #11111b;

        @define-color text     #cdd6f4;
        @define-color subtext0 #a6adc8;
        @define-color subtext1 #bac2de;

        @define-color surface0 #313244;
        @define-color surface1 #45475a;
        @define-color surface2 #585b70;

        @define-color overlay0 #6c7086;
        @define-color overlay1 #7f849c;
        @define-color overlay2 #9399b2;

        @define-color blue      #89b4fa;
        @define-color lavender  #b4befe;
        @define-color sapphire  #74c7ec;
        @define-color sky       #89dceb;
        @define-color teal      #94e2d5;
        @define-color green     #a6e3a1;
        @define-color yellow    #f9e2af;
        @define-color peach     #fab387;
        @define-color maroon    #eba0ac;
        @define-color red       #f38ba8;
        @define-color mauve     #cba6f7;
        @define-color pink      #f5c2e7;
        @define-color flamingo  #f2cdcd;
        @define-color rosewater #f5e0dc;

        .control-center {
          background: @base;
          border-radius: 12px;
          border: 2px solid @blue;
          color: @text;
          padding: 10px;
        }

        .notification-row {
          outline: none;
          margin: 10px;
          padding: 10px;
        }

        .notification-row:focus,
        .notification-row:hover {
          background: @surface0;
          border-radius: 12px;
        }

        .notification {
          background: @mantle;
          border-radius: 12px;
          margin: 6px 12px;
          box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
            0 2px 6px 2px rgba(0, 0, 0, 0.3);
          padding: 10px;
        }

        .notification-content {
          background: @surface0;
          padding: 10px;
          border-radius: 12px;
        }

        .close-button {
          background: @red;
          color: @base;
          text-shadow: none;
          padding: 0;
          border-radius: 100%;
          margin-top: 10px;
          margin-right: 16px;
          box-shadow: none;
          border: none;
          min-width: 24px;
          min-height: 24px;
        }

        .close-button:hover {
          background: @maroon;
          transition: all 0.15s ease-in-out;
        }

        .notification-default-action,
        .notification-action {
          padding: 4px;
          margin: 0;
          box-shadow: none;
          background: @surface0;
          border: 1px solid @surface1;
          color: @text;
          transition: all 0.15s ease-in-out;
        }

        .notification-default-action:hover,
        .notification-action:hover {
          background: @surface1;
        }

        .notification-default-action {
          border-radius: 12px;
        }

        /* When alternative actions are visible */
        .notification-default-action:not(:only-child) {
          border-bottom-left-radius: 0px;
          border-bottom-right-radius: 0px;
        }

        .notification-action {
          border-radius: 0px;
          border-top: none;
          border-right: none;
        }

        /* add bottom border radius to last button */
        .notification-action:last-child {
          border-bottom-left-radius: 10px;
          border-bottom-right-radius: 10px;
        }

        .summary {
          font-size: 16px;
          font-weight: bold;
          background: transparent;
          color: @text;
          text-shadow: none;
        }

        .time {
          font-size: 14px;
          font-weight: bold;
          background: transparent;
          color: @subtext1;
          text-shadow: none;
          margin-right: 18px;
        }

        .body {
          font-size: 15px;
          font-weight: normal;
          background: transparent;
          color: @text;
          text-shadow: none;
        }

        .control-center-list {
          background: transparent;
        }

        .control-center-list-placeholder {
          opacity: 0.5;
        }

        .floating-notifications {
          background: transparent;
        }

        /* Widget specific */
        .widget-title {
          color: @text;
          font-size: 1.5rem;
          margin: 10px;
        }

        .widget-title > button {
          font-size: 1rem;
          color: @text;
          text-shadow: none;
          background: @surface0;
          border: 1px solid @surface1;
          box-shadow: none;
          border-radius: 12px;
          padding: 5px 10px;
          margin: 0px 5px;
        }

        .widget-title > button:hover {
          background: @surface1;
        }

        .widget-dnd {
          font-size: 1.1rem;
          margin: 10px;
        }

        .widget-dnd > switch {
          font-size: initial;
          border-radius: 12px;
          background: @surface0;
          border: 1px solid @surface1;
          box-shadow: none;
        }

        .widget-dnd > switch:checked {
          background: @green;
        }

        .widget-dnd > switch slider {
          background: @surface2;
          border-radius: 12px;
        }
      '';
      description = "CSS styling for SwayNC.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc = {
      "swaync/config.json".source = configFile;
      "swaync/style.css".source = styleFile;
    };

    system.activationScripts = {
      setupSwaync = ''
        echo "Running SwayNC setup script" >> /tmp/swaync_setup.log
        mkdir -p /etc/swaync
        cp -f ${configFile} /etc/swaync/config.json
        cp -f ${styleFile} /etc/swaync/style.css
        chmod 644 /etc/swaync/config.json /etc/swaync/style.css
        echo "SwayNC setup completed" >> /tmp/swaync_setup.log
      '';
    };

    # User-specific setup script
    system.userActivationScripts = {
      setupUserSwaync = ''
        echo "Setting up SwayNC for user $USER" >> /tmp/swaync_user_setup.log
        mkdir -p $HOME/.config/swaync
        ln -sf /etc/swaync/config.json $HOME/.config/swaync/config.json
        ln -sf /etc/swaync/style.css $HOME/.config/swaync/style.css
        echo "User SwayNC setup completed for $USER" >> /tmp/swaync_user_setup.log
      '';
    };

    systemd.user.services.swaync = {
      description = "SwayNC notification daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStartPre = "${debugScript}";
        ExecStart = "${cfg.package}/bin/swaync";
        ExecReload = "${cfg.package}/bin/swaync-client --reload-config";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
