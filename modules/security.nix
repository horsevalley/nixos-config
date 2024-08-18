{ config, pkgs, ... }:

{
  # Security
  # Configure PAM
  security.pam.services = {
    login.gnupg = {
      enable = true;
      storeOnly = true;
    };
    sudo.gnupg = {
      enable = true;
      storeOnly = true;
    };
  };

  security.rtkit.enable = true;
}
