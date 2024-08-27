{ config, pkgs, lib, ... }:

let
  arkenfoxUrl = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
  librewolfSetupScript = pkgs.writeShellScriptBin "setup-librewolf" ''
    PROFILE_DIR="$HOME/.librewolf"
    DEFAULT_PROFILE="$PROFILE_DIR/$(ls $PROFILE_DIR | grep .default)"
    
    if [ ! -d "$DEFAULT_PROFILE" ]; then
      echo "LibreWolf profile not found. Please run LibreWolf at least once before running this script."
      exit 1
    fi

    # Download and set up Arkenfox user.js
    curl -o "$DEFAULT_PROFILE/user.js" ${arkenfoxUrl}
    echo "user_pref(\"browser.startup.homepage\", \"about:home\");" >> "$DEFAULT_PROFILE/user.js"
    echo "user_pref(\"xpinstall.whitelist.required\", false);" >> "$DEFAULT_PROFILE/user.js"

    # Install extensions
    mkdir -p "$DEFAULT_PROFILE/extensions"
    curl -L -o "$DEFAULT_PROFILE/extensions/decentraleyes@decentraleyes.org.xpi" "https://addons.mozilla.org/firefox/downloads/file/3679754/decentraleyes-2.0.17.xpi"
    curl -L -o "$DEFAULT_PROFILE/extensions/idcac-pub@guus.ninja.xpi" "https://addons.mozilla.org/firefox/downloads/file/3896217/i_dont_care_about_cookies-3.4.6.xpi"

    echo "LibreWolf setup complete. Please restart LibreWolf for changes to take effect."
  '';
in
{
  # Install LibreWolf and setup script
  environment.systemPackages = with pkgs; [
    librewolf
    librewolfSetupScript
  ];

  # Ensure LibreWolf uses the correct config directory
  environment.variables = {
    MOZ_LEGACY_PROFILES = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Set LibreWolf policies
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
