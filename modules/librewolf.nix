{ config, pkgs, lib, ... }:

let
  arkenfoxUrl = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
  librewolfProfileDir = "$HOME/.librewolf";
in
{
  # Install LibreWolf and add desktop entry
  environment.systemPackages = with pkgs; [
    (librewolf.override {
      extraExtensions = [
        (fetchFirefoxAddon {
          name = "decentraleyes";
          url = "https://addons.mozilla.org/firefox/downloads/file/3679754/decentraleyes-2.0.17.xpi";
          sha256 = "sha256-11qJnLiX5Z8+1TQ8tE50sWI15+3hxf8HaQpPdj1mFvo=";
        })
        (fetchFirefoxAddon {
          name = "i-dont-care-about-cookies";
          url = "https://addons.mozilla.org/firefox/downloads/file/3896217/i_dont_care_about_cookies-3.4.6.xpi";
          sha256 = "sha256-+uW26qAGZ1zSgZqxV/AlYd8SENXTOWDWQdacwCzz5Bk=";
        })
      ];
    })
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

  # Allow add-on installation
  xdg.configFile."librewolf/librewolf.overrides.cfg".text = ''
    lockPref("xpinstall.whitelist.required", false);
  '';
}
