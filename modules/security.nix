{ config, pkgs, ... }:

{
  # Security
  # Enable polkit
  security.polkit.enable = true;

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

  # Set SUID bit on slock
  security.wrappers.slock = {
    owner = "jonash";
    group = "wheel";
    source = "${pkgs.slock}";
    capabilities = "cap_ipc_lock+ep";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

}
