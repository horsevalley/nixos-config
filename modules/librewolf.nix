{ config, pkgs, lib, ... }:

let
  # Fetch the Arkenfox user.js file from the GitHub repository
  arkenfoxUserJS = pkgs.fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = "108.0";  # Replace with the latest tag if necessary
    sha256 = "1vc8bzz04ni7l15a9yd1x7jn0bw2b6rszg1krp6bcxyj3910pwb7";  # Provided SHA256
  };

  homeDir = builtins.getEnv "HOME";
  xdgConfigHome = builtins.getEnv "XDG_CONFIG_HOME";
  librewolfConfigDir = if xdgConfigHome == "" then "${homeDir}/.config/librewolf" else "${xdgConfigHome}/librewolf";
  librewolfProfile = "${librewolfConfigDir}/ul33mnc7.default";
in
{
  # Ensure Librewolf is installed
  environment.systemPackages = [
    pkgs.librewolf
  ];

  # Move existing profiles to ~/.config/librewolf and set up symlink
  system.activationScripts.librewolfMoveConfig = ''
    mkdir -p ${librewolfConfigDir}

    # If there is already a profile in ~/.librewolf, move it to the new location
    if [ -d "$HOME/.librewolf" ] && [ ! -L "$HOME/.librewolf" ]; then
      mv "$HOME/.librewolf"/* ${librewolfConfigDir}/
      rm -rf "$HOME/.librewolf"
    fi

    # Ensure that ~/.librewolf is a symlink to the new location
    if [ ! -L "$HOME/.librewolf" ]; then
      ln -s ${librewolfConfigDir} "$HOME/.librewolf"
    fi
  '';

  # Copy the user.js file to the correct Librewolf profile directory
  system.activationScripts.librewolfArkenfox = ''
    mkdir -p ${librewolfProfile}
    cp ${arkenfoxUserJS}/user.js ${librewolfProfile}/user.js
  '';
}
