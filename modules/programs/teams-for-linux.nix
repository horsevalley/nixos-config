{ config, lib, pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "teams-for-linux" ''
        export GDK_BACKEND=x11
        export WEBKIT_FORCE_SANDBOX=0
        exec ${pkgs.teams-for-linux}/bin/teams-for-linux "$@"
      '')
    ];
  };
}
