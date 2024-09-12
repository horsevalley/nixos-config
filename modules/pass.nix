{ config, pkgs, lib, ... }:

let
  # Replace this with your actual username
  username = "jonash";
in
{
  # Install pass and related tools
  environment.systemPackages = with pkgs; [
    pass
    gnupg
    pinentry
  ];

  # Set the PASSWORD_STORE_DIR environment variable
  environment.variables = {
    PASSWORD_STORE_DIR = lib.mkForce "$HOME/.local/share/password-store";
  };

  # Add shell initialization for pass
  environment.shellInit = ''
    # Ensure PASSWORD_STORE_DIR is set correctly
    export PASSWORD_STORE_DIR="$HOME/.local/share/password-store"

    # Ensure PASSWORD_STORE_DIR exists and has correct permissions
    if [[ ! -d "$PASSWORD_STORE_DIR" ]]; then
      mkdir -p "$PASSWORD_STORE_DIR"
      chmod 700 "$PASSWORD_STORE_DIR"
    fi

    # Initialize pass if .gpg-id doesn't exist
    if [[ ! -f "$PASSWORD_STORE_DIR/.gpg-id" ]]; then
      echo "Initializing password store..."
      pass init "Your GPG Key ID or Email"
    fi
  '';

  # Ensure GPG agent is configured correctly
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
