{ config, pkgs, lib, ... }:

let
  arkenfoxUrl = "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js";
in
{
  # Install LibreWolf
  environment.systemPackages = with pkgs; [
    librewolf
  ];

  # Set up Arkenfox user.js for each user
  system.activationScripts.setupLibrewolf = ''
    for user in /home/*; do
      if [ -d "$user" ]; then
        username=$(basename "$user")
        librewolf_dir="/home/$username/.librewolf"
        mkdir -p "$librewolf_dir"
        chown $username:users "$librewolf_dir"
        
        # Find or create default profile
        default_profile=$(find "$librewolf_dir" -maxdepth 1 -type d -name "*.default" | head -n 1)
        if [ -z "$default_profile" ]; then
          default_profile="$librewolf_dir/$(openssl rand -hex 4).default"
          mkdir -p "$default_profile"
          chown $username:users "$default_profile"
        fi
        
        # Download Arkenfox user.js
        ${pkgs.curl}/bin/curl -o "$default_profile/user.js" ${arkenfoxUrl}
        chown $username:users "$default_profile/user.js"
        
        echo "LibreWolf setup complete for user $username"
      fi
    done
  '';

  # Enable Wayland support
  environment.variables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
