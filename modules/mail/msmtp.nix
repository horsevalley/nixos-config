{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.msmtp ];

  environment.etc."msmtprc".text = ''
    # Set default values for all following accounts.
    defaults
    auth           on
    tls            on
    tls_trust_file /etc/ssl/certs/ca-certificates.crt
    logfile        /var/log/msmtp.log

    # jonash@jonash.xyz
    account        jonash@jonash.xyz
    host           mail.jonash.xyz
    port           587
    from           jonash@jonash.xyz
    user           jonash@jonash.xyz
    passwordeval   "pass email/jonash@jonash.xyz"

    # Set a default account
    account default : jonash@jonash.xyz
  '';

  # Ensure the log file exists and is writable
  system.activationScripts.msmtpLogFile = ''
    touch /var/log/msmtp.log
    chmod 660 /var/log/msmtp.log
    chown root:mail /var/log/msmtp.log
  '';
}
