{ config, pkgs, lib, ... }:

let
  arkenfoxUrl = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
  librewolfProfileDir = "$HOME/.librewolf";
  decentraleyesUrl = "https://addons.mozilla.org/firefox/downloads/file/3679754/decentraleyes-2.0.17.xpi";
  clearurlsUrl = "https://addons.mozilla.org/firefox/downloads/file/3986147/clearurls-1.25.0.xpi";
in
{
  environment.systemPackages = with pkgs; [
    librewolf
    (writeShellScriptBin "librewolf-setup" ''
      #!/bin/bash
      set -e

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

      # Function to download with retry
      download_with_retry() {
        local url=$1
        local output=$2
        local max_retries=3
        local retry_count=0

        while [ $retry_count -lt $max_retries ]; do
          if curl -L -o "$output" "$url"; then
            if [ -s "$output" ]; then
              echo "Successfully downloaded $(basename "$output")"
              return 0
            else
              echo "Downloaded file is empty. Retrying..."
            fi
          else
            echo "Download failed. Retrying..."
          fi
          retry_count=$((retry_count + 1))
          sleep 5
        done

        echo "Failed to download $url after $max_retries attempts"
        return 1
      }

      # Download and set up Arkenfox user.js
      echo "Downloading Arkenfox user.js..."
      download_with_retry ${arkenfoxUrl} "$DEFAULT_PROFILE/user.js"
      echo "user_pref(\"browser.startup.homepage\", \"about:home\");" >> "$DEFAULT_PROFILE/user.js"
      echo "user_pref(\"xpinstall.whitelist.required\", false);" >> "$DEFAULT_PROFILE/user.js"

      # Create extensions directory if it doesn't exist
      mkdir -p "$DEFAULT_PROFILE/extensions"
      echo "Extensions directory created/verified."

      # Download and install extensions
      echo "Downloading Decentraleyes..."
      download_with_retry ${decentraleyesUrl} "$DEFAULT_PROFILE/extensions/decentraleyes@decentraleyes.org.xpi"
      
      echo "Downloading ClearURLs..."
      download_with_retry ${clearurlsUrl} "$DEFAULT_PROFILE/extensions/{74145f27-f039-47ce-a470-a662b129930a}.xpi"

      echo "Verifying extension files..."
      ls -l "$DEFAULT_PROFILE/extensions"

      # Check if the downloaded files are not empty
      if [ ! -s "$DEFAULT_PROFILE/extensions/decentraleyes@decentraleyes.org.xpi" ]; then
        echo "Error: Decentraleyes extension file is empty or not downloaded correctly."
        exit 1
      fi

      if [ ! -s "$DEFAULT_PROFILE/extensions/{74145f27-f039-47ce-a470-a662b129930a}.xpi" ]; then
        echo "Error: ClearURLs extension file is empty or not downloaded correctly."
        exit 1
      fi

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
      Preferences = {
        "services.settings.server" = {
          Value = "https://example.com";
          Status = "locked";
        };
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
      };
    };
  };
}
