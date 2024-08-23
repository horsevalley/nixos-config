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

  # Set SUID bit on slock
  security.wrappers.slock = {
    owner = "root";
    group = "root";
    source = "${pkgs.slock}nix/store/rlhf18hnaik6nhiq1i1y51bj386jybm9-system-path/bin/slock";
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
