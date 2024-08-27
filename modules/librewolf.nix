{ config, pkgs, lib, ... }:

let
  arkenfoxUrl = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
  librewolfProfileDir = "$HOME/.librewolf";
  decentraleyesUrl = "https://addons.mozilla.org/firefox/downloads/file/3679754/decentraleyes-2.0.17.xpi";
  idcacUrl = "https://addons.mozilla.org/firefox/downloads/file/3896217/i_dont_care_about_cookies-3.4.6.xpi";
in
{
  environment.systemPackages = with pkgs; [
    librewolf
    (writeShellScriptBin "librewolf-setup" ''
      #!/bin/sh
      set -ex

      echo "Starting LibreWolf setup script..."

      # Wait for LibreWolf to create the profile
      while [ ! -d "${librewolfProfileDir}" ]; do
        echo "Waiting for LibreWolf profile to be created..."
        sleep 1
      done

      echo "LibreWolf profile directory found."

      # Find the default profile directory
      DEFAULT_PROFILE=$(find ${librewolfProfileDir} -maxdepth 1 -type d -name "*.default" | head -n 1)

      if [ -z "$DEFAULT_PROFILE" ]; then
        echo "Error: LibreWolf profile not found. Please run LibreWolf at least once before running this script."
        exit 1
      fi

      echo "Default profile found at: $DEFAULT_PROFILE"

      # Download and set up Arkenfox user.js
      echo "Downloading Arkenfox user.js..."
      curl -o "$DEFAULT_PROFILE/user.js" ${arkenfoxUrl}
      echo "user_pref(\"browser.startup.homepage\", \"about:home\");" >> "$DEFAULT_PROFILE/user.js"
      echo "user_pref(\"xpinstall.whitelist.required\", false);" >> "$DEFAULT_PROFILE/user.js"

      # Create extensions directory if it doesn't exist
      mkdir -p "$DEFAULT_PROFILE/extensions"
      echo "Extensions directory created/verified."

      # Download and install extensions
      echo "Downloading Decentraleyes..."
      curl -L -o "$DEFAULT_PROFILE/extensions/decentraleyes@decentraleyes.org.xpi" "${decentraleyesUrl}"
      echo "Downloading I Don't Care About Cookies..."
      curl -L -o "$DEFAULT_PROFILE/extensions/idcac-pub@guus.ninja.xpi" "${idcacUrl}"

      echo "Verifying extension files..."
      ls -l "$DEFAULT_PROFILE/extensions"

      echo "LibreWolf setup complete. Please restart LibreWolf for changes to take effect."
    '')
  ];

  environment.variables = {
    MOZ_LEGACY_PROFILES = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.etc."librewolf/policies/policies.json".text = builtins.toJSON {
    policies = {
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      NoDefaultBookmarks = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      ExtensionSettings = {
        "*" = {
          installation_mode = "allowed";
        };
      };
    };
  };
}
