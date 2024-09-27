{ config, lib, pkgs, ... }:

let
  obsWebSocketPort = 4444;
  myObs = pkgs.wrapOBS {
    plugins = with pkgs.obs-studio-plugins; [
      obs-websocket
    ];
  };
in
{
  # Install our custom OBS Studio with websocket plugin, and obs-cli
  environment.systemPackages = [
    myObs
    pkgs.obs-cli
  ];

  # Set up a systemd service to ensure OBS starts on login
  systemd.user.services.obs-studio = {
    description = "OBS Studio";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${myObs}/bin/obs --minimize-to-tray --startreplaybuffer --studio-mode";
      Restart = "on-failure";
      Environment = "QT_QPA_PLATFORM=wayland";
    };
  };

  # Create configuration files for OBS Studio
  system.activationScripts = {
    obsUserConfig = {
      text = ''
        set -e
        for user in ${lib.concatStringsSep " " (builtins.attrNames config.users.users)}; do
          if [ "$user" != "root" ] && [ -d "/home/$user" ]; then
            user_home="/home/$user"
            config_dir="$user_home/.config/obs-studio"
            mkdir -p "$config_dir"
            
            # Global settings
            cat > "$config_dir/global.ini" <<EOF
[General]
MinimizeToTray=true

[WebsocketServer]
Enabled=true
Port=${toString obsWebSocketPort}
EOF

            # Main OBS config
            mkdir -p "$config_dir/basic/profiles/Untitled"
            cat > "$config_dir/basic/profiles/Untitled/basic.ini" <<EOF
[General]
Name=Untitled

[WebsocketAPI]
ServerEnabled=true
ServerPort=${toString obsWebSocketPort}
EOF

            chown -R "$user:users" "$config_dir"
          fi
        done
      '';
    };
  };
}
