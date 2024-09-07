{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.msmtp;
in {
  options.programs.msmtp = {
    enable = mkEnableOption "msmtp mail sending agent";

    package = mkOption {
      type = types.package;
      default = pkgs.msmtp;
      defaultText = literalExpression "pkgs.msmtp";
      description = "The msmtp package to use.";
    };

    configFile = mkOption {
      type = types.lines;
      default = "";
      description = "msmtp configuration";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional msmtp configuration";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."msmtprc".text = ''
      # Default settings for all accounts
      defaults
      auth           on
      tls            on
      tls_trust_file /etc/ssl/certs/ca-certificates.crt
      logfile        ~/.msmtp.log

      # Personal account
      account        personal
      host           smtp.example.com
      port           587
      from           jonash@jonash.xyz
      user           jonash@jonash.xyz
      passwordeval   "pass email/jonash@jonash.xyz"

      # Set the default account
      account default : personal

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

    security.wrappers.msmtp = {
      source = "${cfg.package}/bin/msmtp";
      owner = "root";
      group = "root";
      setuid = true;
    };
  };
}
