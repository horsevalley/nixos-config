{ config, lib, pkgs, ... }:

let
  obs-cmd = pkgs.writeScriptBin "obs-cmd" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.obs-studio}/bin/obs-cli "$@"
  '';
in
{
  # Enable OBS Studio
  programs.obs-studio = {
    enable = true;
  };

  # Make obs-cmd available system-wide
  environment.systemPackages = [ obs-cmd ];

  # Set up a systemd service to ensure OBS starts on login
  systemd.user.services.obs-studio = {
    description = "OBS Studio";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.obs-studio}/bin/obs --minimize-to-tray";
      Restart = "on-failure";
    };
  };

  # Create a basic configuration file for OBS Studio in the user's home directory
  system.activationScripts = {
    obsUserConfig = {
      text = ''
        mkdir -p ~/.config/obs-studio
        cat > ~/.config/obs-studio/global.ini <<EOF
[General]
MinimizeToTray=true
EOF
        chown -R $USER:$USER ~/.config/obs-studio
      '';
      deps = [];
    };
  };
}
