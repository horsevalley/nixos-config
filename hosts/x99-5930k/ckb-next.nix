{ config, lib, pkgs, ... }:

let
  scimitarProfile = ''
    {
        "name": "Scimitar",
        "guid": "{00000000-0000-0000-0000-000000000000}",
        "modified": ${toString (builtins.currentTime * 1000)},
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
  # Enable ckb-next service
  services.ckb-next = {
    enable = true;
    package = pkgs.ckb-next;
  };

  # Install ckb-next package
  environment.systemPackages = [ pkgs.ckb-next ];

  # Configure udev rules for Corsair Scimitar mouse
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="1b8b", MODE="0666"
  '';

  # Setup ckb-next configuration
  environment.etc."ckb-next/ckb-next.conf".text = ''
    [General]
    AutoStart=true
    CloseToTray=true

    [Devices]
    ScimitarPro\DPI=800,1600,3200
    ScimitarPro\Polling=1
  '';

  # Create ckb-next profile
  system.userActivationScripts.setupCkbNextProfile = {
    text = ''
      mkdir -p ~/.config/ckb-next/profiles
      cat > ~/.config/ckb-next/profiles/Scimitar.ckbprofile << EOF
      ${scimitarProfile}
      EOF
    '';
    deps = [];
  };

  # Systemd service to load ckb-next profile on startup
  systemd.user.services.ckb-next-load-profile = {
    description = "Load ckb-next profile for Scimitar mouse";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ckb-next}/bin/ckb-next-daemon -p ~/.config/ckb-next/profiles/Scimitar.ckbprofile";
    };
  };
}
