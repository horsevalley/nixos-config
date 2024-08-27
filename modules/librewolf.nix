{ config, pkgs, lib, ... }:

let
  arkenfoxUrl = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
  librewolfProfileDir = "$HOME/.librewolf";
in
{
  # Install LibreWolf and add desktop entry
  environment.systemPackages = with pkgs; [
    librewolf
    (makeDesktopItem {
      name = "librewolf";
      exec = "librewolf %U";
      icon = "librewolf";
      desktopName = "LibreWolf";
      genericName = "Web Browser";
      categories = [ "Network" "WebBrowser" ];
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "application/vnd.mozilla.xul+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/ftp"
      ];
    })
  ];

  # Download and set up Arkenfox user.js
  systemd.user.services.setup-librewolf-arkenfox = {
    description = "Set up LibreWolf with Arkenfox user.js";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "setup-librewolf-arkenfox" ''
        PROFILE_DIR="${librewolfProfileDir}"
        mkdir -p "$PROFILE_DIR"
        ${pkgs.curl}/bin/curl -o "$PROFILE_DIR/user.js" ${arkenfoxUrl}
        echo "user_pref(\"browser.startup.homepage\", \"about:home\");" >> "$PROFILE_DIR/user.js"
        
        # Find the default profile directory
        DEFAULT_PROFILE=$(find "$PROFILE_DIR" -maxdepth 1 -type d -name "*.default" | head -n 1)
        if [ -n "$DEFAULT_PROFILE" ]; then
          # Copy user.js to the default profile directory
          cp "$PROFILE_DIR/user.js" "$DEFAULT_PROFILE/user.js"
        fi
      '';
    };
  };

  # Ensure LibreWolf uses the correct config directory
  environment.variables = {
    MOZ_LEGACY_PROFILES = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
