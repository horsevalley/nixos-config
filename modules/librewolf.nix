{ config, pkgs, lib, ... }:

let
  # Fetch the Arkenfox user.js file from the GitHub repository
  arkenfoxUserJS = pkgs.fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = "108.0";  # Replace with the latest tag if necessary
    sha256 = "1vc8bzz04ni7l15a9yd1x7jn0bw2b6rszg1krp6bcxyj3910pwb7";  # Provided SHA256
  };

  # Manually construct the Librewolf profile path
  homeDir = builtins.getEnv "HOME";
  librewolfProfile = "${homeDir}/.config/librewolf/ul33mnc7.default";  # Adjust the profile directory name as needed
in
{
  # Ensure Librewolf is installed
  environment.systemPackages = [
    pkgs.librewolf
  ];

  # Add a script to copy the user.js file to the Librewolf profile
  system.activationScripts.librewolfArkenfox = ''
    mkdir -p ${librewolfProfile}
    cp ${arkenfoxUserJS}/user.js ${librewolfProfile}/user.js
  '';
}
