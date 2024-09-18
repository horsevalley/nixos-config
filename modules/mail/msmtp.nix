{ config, pkgs, lib, ... }:

let
  username = "jonash";  # Replace with your actual username
in
{
  environment.systemPackages = [ pkgs.msmtp ];

  system.activationScripts.msmtpSetup = ''
    # Ensure XDG config directory exists
    mkdir -p /home/${username}/.config/msmtp

    # Create msmtp config file
    cat > /home/${username}/.config/msmtp/config << EOL
    # Set default values for all following accounts.
    defaults
    auth           on
    tls            on
    tls_trust_file /etc/ssl/certs/ca-certificates.crt
    logfile        ~/.config/msmtp/msmtp.log

    # jonash@jonash.xyz
    account        jonash@jonash.xyz
    host           mail.jonash.xyz
    port           587
    from           jonash@jonash.xyz
    user           jonash@jonash.xyz
    passwordeval   "pass email/jonash@jonash.xyz"

    # Set a default account
    account default : jonash@jonash.xyz
    EOL

    # Create log file
    touch /home/${username}/.config/msmtp/msmtp.log

    # Set correct permissions
    chown -R ${username}:users /home/${username}/.config/msmtp
    chmod 600 /home/${username}/.config/msmtp/config
    chmod 600 /home/${username}/.config/msmtp/msmtp.log
  '';

  # Create a symlink for compatibility with some programs
  system.activationScripts.msmtpCompatibility = ''
    ln -sf /home/${username}/.config/msmtp/config /home/${username}/.msmtprc
  '';
}
