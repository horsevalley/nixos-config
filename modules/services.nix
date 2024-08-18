{ config, pkgs, ... }:

{
  # Enable CUPS to print documents
  services.printing.enable = true; 

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;
}
