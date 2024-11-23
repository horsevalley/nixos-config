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

    # Create desktop entry
    environment.systemPackages = with pkgs; [
      (makeDesktopItem {
        name = "teams-for-linux";
        desktopName = "Teams for Linux";
        exec = "teams-for-linux";
        icon = "${pkgs.teams-for-linux}/share/icons/hicolor/512x512/apps/teams-for-linux.png";
        categories = [ "Network" "InstantMessaging" ];
        terminal = false;
      })
    ];
  };
}
