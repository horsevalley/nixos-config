# This module configures msmtp, a simple mail transfer agent used for sending emails.
# It's part of a larger email setup including neomutt for reading and isync for syncing.

{ config, lib, pkgs, ... }:

with lib;

let
  # This lets us refer to the user's msmtp configuration options easily
  cfg = config.programs.msmtp;
in {
  options = {
    programs.msmtp = {
      # Option to enable or disable msmtp
      enable = mkEnableOption "msmtp mail sending agent";

      # Option to specify which msmtp package to use
      package = mkOption {
        type = types.package;
        default = pkgs.msmtp;
        defaultText = literalExpression "pkgs.msmtp";
        description = "The msmtp package to use.";
      };

      # Option for additional msmtp configuration
      configFile = mkOption {
        type = types.lines;
        default = "";
        description = "Additional msmtp configuration";
      };

      # Option for any extra configuration that doesn't fit elsewhere
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Any extra msmtp configuration";
      };
    };
  };

  # The actual configuration to apply when msmtp is enabled
  config = mkIf cfg.enable {
    # Ensure msmtp is installed
    environment.systemPackages = [ cfg.package ];

    # Create the msmtp configuration file
    environment.etc."msmtprc".text = ''
      # Default settings for all accounts
      defaults
      auth           on
      tls            on
      tls_trust_file /etc/ssl/certs/ca-certificates.crt
      logfile        ~/.msmtp.log

      # Personal account configuration
      account        personal
      host           mail.jonash.xyz
      port           587
      from           jonash@jonash.xyz
      user           jonash@jonash.xyz
      passwordeval   "pass email/jonash@jonash.xyz"  # Use 'pass' for secure password retrieval

      # Set the default account to use
      account default : personal

      # Include user's additional configuration
      ${cfg.configFile}
      ${cfg.extraConfig}
    '';

    # Set msmtp as the system's default mailer
    environment.etc."aliases".text = ''
      root: jonash@jonash.xyz
      default: jonash@jonash.xyz
    '';
    environment.etc."mailname".text = "mail.jonash.xyz";
    environment.etc."mail.rc".text = ''
      set sendmail=/run/wrappers/bin/msmtp
    '';

    # Set up a security wrapper for msmtp
    # This allows msmtp to be run with elevated privileges when needed
    security.wrappers.msmtp = {
      source = "${cfg.package}/bin/msmtp";
      owner = "root";
      group = "root";
      setuid = true;
    };
  };
}
