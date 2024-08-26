{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.eww;
  # Assume the main user is the one running X11/Wayland
  mainUser = config.users.users.${config.services.xserver.displayManager.defaultUser or "defaultUser"};
in {
  options.services.eww = {
    enable = mkEnableOption "eww";
    package = mkOption {
      type = types.package;
      default = pkgs.eww-wayland;
      description = "The eww package to use.";
    };
    configDir = mkOption {
      type = types.str;
      default = "$HOME/.config/eww";
      description = "The directory containing eww configuration files, relative to the user's home.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Create eww configuration files in the user's home directory
    system.activationScripts.ewwUserConfig = ''
      mkdir -p ${mainUser.home}/${cfg.configDir}
      cat > ${mainUser.home}/${cfg.configDir}/eww.yuck << EOF
			(defwindow bar
				:monitor 0
				:geometry (geometry :x "0%"
														:y "0%"
														:width "100%"
														:height "30px"
														:anchor "top center")
				:stacking "fg"
				:reserve (struts :distance "30px" :side "top")
				:windowtype "dock"
				:wm-ignore false
				(bar))

			(defwidget bar []
				(box :class "bar"
						 :orientation "h"
					(workspaces)
					(time)))

			(defwidget workspaces []
				(box :class "workspaces"
						 :orientation "h"
						 :space-evenly true
						 :halign "start"
					(button :onclick "hyprctl dispatch workspace 1" "1")
					(button :onclick "hyprctl dispatch workspace 2" "2")
					(button :onclick "hyprctl dispatch workspace 3" "3")
					(button :onclick "hyprctl dispatch workspace 4" "4")
					(button :onclick "hyprctl dispatch workspace 5" "5")))

			(defwidget time []
				(box :class "time"
						 :halign "end"
					(label :text {formattime(EWW_TIME, "%H:%M")})))

			(defpoll time :interval "1s"
				\`date +%H:%M\`)
			EOF

						cat > ${mainUser.home}/${cfg.configDir}/eww.scss << EOF
			* {
				all: unset;
			}

			.bar {
				background-color: #282a36;
				color: #f8f8f2;
				font-family: "JetBrainsMono Nerd Font";
				font-size: 14px;
			}

			.workspaces button {
				padding: 0 10px;
			}

			.time {
				padding-right: 10px;
			}
			EOF

      chown -R ${mainUser.name}:${mainUser.group} ${mainUser.home}/${cfg.configDir}
    '';

    # Add a systemd user service to start eww
    systemd.user.services.eww = {
      description = "Eww Daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/eww daemon --config ${mainUser.home}/${cfg.configDir}";
        Restart = "always";
        RestartSec = 3;
      };
    };
  };
}
