{ config, pkgs, ... }:

let
  # Fetch the Arkenfox user.js file from the GitHub repository
  arkenfoxUserJS = pkgs.fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = "108.0";  # Replace with the latest tag if necessary
    sha256 = "lib.fakeSha256"; # Replace with the actual SHA256
  };

  librewolfProfile = "$XDG_CONFIG_HOME/librewolf";  # Adjust this path if your profile is in a different location
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
