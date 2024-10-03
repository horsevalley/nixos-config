{ config, lib, pkgs, ... }:

let
  getPassword = pkgs.writeScript "get-obs-password" ''
    #!/usr/bin/env bash
    ${pkgs.pass}/bin/pass obs-websocket-password
  '';

  obs-cli-config = pkgs.writeText "obs-cli-config.toml" ''
    [connection]
    host = "localhost"
    port = 4444
    password = "$OBS_WEBSOCKET_PASSWORD"
  '';

  obs-config = pkgs.writeText "obs-studio.json" ''
    {
        "BasicSettings": {
            "RecordingPath": "/home/jonash/recordings/obs-studio"
        },
        "WebsocketServerSettings": {
            "ServerEnabled": true,
            "ServerPort": 4444,
            "AuthRequired": true,
            "ServerPassword": "$OBS_WEBSOCKET_PASSWORD"
        }
    }
  '';

  start-recording-script = pkgs.writeScriptBin "start-obs-recording" ''
    #!/usr/bin/env bash
    export OBS_WEBSOCKET_PASSWORD=$(${getPassword})
    ${pkgs.obs-cli}/bin/obs-cli recording start
  '';

  stop-recording-script = pkgs.writeScriptBin "stop-obs-recording" ''
    #!/usr/bin/env bash
    export OBS_WEBSOCKET_PASSWORD=$(${getPassword})
    ${pkgs.obs-cli}/bin/obs-cli recording stop
  '';

in
{
  environment.systemPackages = with pkgs; [
    obs-studio
    obs-cli
    pass
    start-recording-script
    stop-recording-script
  ];

  # Enable WebSocket server in OBS Studio
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-websocket
    ];
  };

  # Set up obs-cli configuration
  environment.etc."obs-cli/config.toml".source = obs-cli-config;

  # Set up OBS Studio configuration
  environment.etc."obs-studio/global.ini".source = obs-config;

  # Ensure the necessary directories exist and set up OBS with the password
  system.activationScripts = {
    obsSetup = ''
      mkdir -p /etc/obs-cli
      mkdir -p /etc/obs-studio
      mkdir -p /home/jonash/recordings/obs-studio
      chown jonash:users /home/jonash/recordings/obs-studio

      # Replace placeholder with actual password in obs-cli config
      sed -i "s/\$OBS_WEBSOCKET_PASSWORD/$(${getPassword})/" /etc/obs-cli/config.toml

      # Replace placeholder with actual password in OBS Studio config
      sed -i "s/\$OBS_WEBSOCKET_PASSWORD/$(${getPassword})/" /etc/obs-studio/global.ini
    '';
  };
}
