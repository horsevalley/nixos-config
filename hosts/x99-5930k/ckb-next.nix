{ config, lib, pkgs, ... }:
let
  scimitarProfile = ''
    {
        "name": "Scimitar",
        "guid": "{00000000-0000-0000-0000-000000000000}",
        "modified": 1700000000000,
        "modes": [
            {
                "name": "Default",
                "buttons": [
                    {"key": "g1", "bind": "1"},
                    {"key": "g2", "bind": "2"},
                    {"key": "g3", "bind": "3"},
                    {"key": "g4", "bind": "4"},
                    {"key": "g5", "bind": "5"},
                    {"key": "g6", "bind": "6"},
                    {"key": "g7", "bind": "7"},
                    {"key": "g8", "bind": "8"},
                    {"key": "g9", "bind": "9"},
                    {"key": "g10", "bind": "0"},
                    {"key": "g11", "bind": "-"},
                    {"key": "g12", "bind": "="}
                ]
            }
        ]
    }
  '';
in
{
  # Install ckb-next package
  environment.systemPackages = [ pkgs.ckb-next ];

  # Configure udev rules for Corsair Scimitar mouse
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b8b", MODE="0666"
  '';

  # Create ckb-next profile
  system.activationScripts.setupCkbNextProfile = {
    text = ''
      mkdir -p /var/lib/ckb-next/profiles
      cat > /var/lib/ckb-next/profiles/Scimitar.ckbprofile << EOF
      ${scimitarProfile}
      EOF
    '';
    deps = [];
  };

  # Systemd service to start ckb-next daemon
  systemd.services.ckb-next-daemon = {
    description = "Corsair RGB Keyboard Daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.ckb-next}/bin/ckb-next-daemon -n";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  # Systemd service to load ckb-next profile
  systemd.services.ckb-next-load-profile = {
    description = "Load ckb-next profile for Scimitar mouse";
    after = [ "ckb-next-daemon.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 5 && ${pkgs.ckb-next}/bin/ckb-next-daemon -c loadprofile:/var/lib/ckb-next/profiles/Scimitar.ckbprofile'";
      RemainAfterExit = "yes";
    };
  };

  # Enable verbose logging for ckb-next-daemon
  environment.etc."ckb-next/ckb-next.conf".text = ''
    [General]
    VerboseLogging=true
  '';
}
