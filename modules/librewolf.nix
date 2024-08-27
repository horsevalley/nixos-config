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
  librewolfConfigDir = "${homeDir}/.config/librewolf";
  librewolfProfile = "${librewolfConfigDir}/ul33mnc7.default";
in
{
  # Ensure Librewolf is installed
  environment.systemPackages = [
    pkgs.librewolf
  ];

  # Create the ~/.config/librewolf directory and link ~/.librewolf to it
  system.activationScripts.librewolfConfigDir = ''
    mkdir -p ${librewolfConfigDir}
    if [ ! -d "$HOME/.librewolf" ]; then
      ln -s ${librewolfConfigDir} $HOME/.librewolf
    fi
  '';

  # Copy the user.js file to the correct Librewolf profile directory
  system.activationScripts.librewolfArkenfox = ''
    mkdir -p ${librewolfProfile}
    cp ${arkenfoxUserJS}/user.js ${librewolfProfile}/user.js
  '';
}
