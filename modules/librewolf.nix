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

      # Check if the downloaded files are not empty
      if [ ! -s "$DEFAULT_PROFILE/extensions/decentraleyes@decentraleyes.org.xpi" ]; then
        echo "Error: Decentraleyes extension file is empty or not downloaded correctly."
        exit 1
      fi

      if [ ! -s "$DEFAULT_PROFILE/extensions/idcac-pub@guus.ninja.xpi" ]; then
        echo "Error: I Don't Care About Cookies extension file is empty or not downloaded correctly."
        exit 1
      fi

      # Create a extensions.json file to help LibreWolf recognize the extensions
      cat << EOF > "$DEFAULT_PROFILE/extensions.json"
      {
        "schemaVersion": 36,
        "addons": [
          {
            "id": "decentraleyes@decentraleyes.org",
            "version": "2.0.17",
            "type": "extension",
            "loader": null,
            "updateURL": null,
            "optionsURL": null,
            "optionsType": null,
            "optionsBrowserStyle": true,
            "aboutURL": null,
            "defaultLocale": {
              "name": "Decentraleyes"
            },
            "visible": true,
            "active": true,
            "userDisabled": false,
            "appDisabled": false,
            "installDate": $(date +%s)000,
            "updateDate": $(date +%s)000,
            "applyBackgroundUpdates": 1,
            "path": "$DEFAULT_PROFILE/extensions/decentraleyes@decentraleyes.org.xpi",
            "skinnable": false,
            "sourceURI": null,
            "releaseNotesURI": null,
            "softDisabled": false,
            "foreignInstall": false,
            "strictCompatibility": true,
            "locales": [],
            "targetApplications": [
              {
                "id": "{ec8030f7-c20a-464f-9b0e-13a3a9e97384}",
                "minVersion": "52.0",
                "maxVersion": "*"
              }
            ],
            "targetPlatforms": [],
            "seen": true,
            "dependencies": [],
            "incognito": "spanning",
            "userPermissions": null,
            "icons": {},
            "iconURL": null,
            "blocklistState": 0,
            "blocklistURL": null,
            "startupData": null,
            "hidden": false,
            "installTelemetryInfo": null,
            "recommendationState": null,
            "rootURI": "jar:file://$DEFAULT_PROFILE/extensions/decentraleyes@decentraleyes.org.xpi!/",
            "location": "app-profile"
          },
          {
            "id": "idcac-pub@guus.ninja",
            "version": "3.4.6",
            "type": "extension",
            "loader": null,
            "updateURL": null,
            "optionsURL": null,
            "optionsType": null,
            "optionsBrowserStyle": true,
            "aboutURL": null,
            "defaultLocale": {
              "name": "I Don't Care About Cookies"
            },
            "visible": true,
            "active": true,
            "userDisabled": false,
            "appDisabled": false,
            "installDate": $(date +%s)000,
            "updateDate": $(date +%s)000,
            "applyBackgroundUpdates": 1,
            "path": "$DEFAULT_PROFILE/extensions/idcac-pub@guus.ninja.xpi",
            "skinnable": false,
            "sourceURI": null,
            "releaseNotesURI": null,
            "softDisabled": false,
            "foreignInstall": false,
            "strictCompatibility": true,
            "locales": [],
            "targetApplications": [
              {
                "id": "{ec8030f7-c20a-464f-9b0e-13a3a9e97384}",
                "minVersion": "52.0",
                "maxVersion": "*"
              }
            ],
            "targetPlatforms": [],
            "seen": true,
            "dependencies": [],
            "incognito": "spanning",
            "userPermissions": null,
            "icons": {},
            "iconURL": null,
            "blocklistState": 0,
            "blocklistURL": null,
            "startupData": null,
            "hidden": false,
            "installTelemetryInfo": null,
            "recommendationState": null,
            "rootURI": "jar:file://$DEFAULT_PROFILE/extensions/idcac-pub@guus.ninja.xpi!/",
            "location": "app-profile"
          }
        ]
      }
      EOF

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
