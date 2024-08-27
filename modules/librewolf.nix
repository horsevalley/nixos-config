{ config, pkgs, lib, ... }:

let
  arkenfoxUrl = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
  xdgConfigHome = "$HOME/.config";
in
{
  # Enable LibreWolf
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;
  };

  # Download and set up Arkenfox user.js
  systemd.user.services.setup-librewolf-arkenfox = {
    description = "Set up LibreWolf with Arkenfox user.js";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "setup-librewolf-arkenfox" ''
        mkdir -p ${xdgConfigHome}/librewolf
        ${pkgs.curl}/bin/curl -o ${xdgConfigHome}/librewolf/user.js ${arkenfoxUrl}
        echo "user_pref(\"browser.startup.homepage\", \"about:home\");" >> ${xdgConfigHome}/librewolf/user.js
      '';
    };
  };

  # Set XDG_CONFIG_HOME
  environment.variables = {
    XDG_CONFIG_HOME = xdgConfigHome;
  };

  # Ensure LibreWolf uses the correct config directory
  environment.shellInit = ''
    export MOZ_LEGACY_PROFILES=1
    export MOZ_ENABLE_WAYLAND=1
  '';
}
