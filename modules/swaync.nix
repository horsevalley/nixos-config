{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.swaync;
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

    systemdTarget = mkOption {
      type = types.str;
      default = "graphical-session.target";
      description = "The systemd target to bind to.";
    };

    style = mkOption {
      type = types.lines;
      default = '''';
      description = "CSS styling for SwayNC.";
    };

    config = mkOption {
      type = types.attrs;
      default = {};
      description = "SwayNC configuration options.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.swaync = {
      description = "SwayNC notification daemon";
      wantedBy = [ cfg.systemdTarget ];
      partOf = [ cfg.systemdTarget ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${cfg.package}/bin/swaync";
        ExecReload = "${cfg.package}/bin/swaync-client --reload-config";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    xdg.configFile."swaync/config.json".text = builtins.toJSON (recursiveUpdate {
      # Default configuration
      "$schema": "/etc/xdg/swaync/configSchema.json";
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
      scripts = {};
      notification-visibility = {};
      widgets = [
        "title"
        "dnd"
        "notifications"
        "mpris"
      ];
    } cfg.config);

    xdg.configFile."swaync/style.css".text = cfg.style;
  };
}
