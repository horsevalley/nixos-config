# This module configures isync (mbsync), which synchronizes emails between a local maildir and a remote IMAP server.
# It's part of a larger email setup including neomutt for reading and msmtp for sending.

{ config, lib, pkgs, ... }:

with lib;

let
  # This lets us refer to the user's mbsync configuration options easily
  cfg = config.services.mbsync;
  # Define the base mail directory
  maildir = "~/.mail";
in {
  options.services.mbsync = {
    # Option to enable or disable mbsync
    enable = mkEnableOption "mbsync email synchronization";

    # Option to specify which isync package to use
    package = mkOption {
      type = types.package;
      default = pkgs.isync;
      defaultText = literalExpression "pkgs.isync";
      description = "The isync package to use.";
    };

    # Option for additional mbsync configuration
    configFile = mkOption {
      type = types.lines;
      default = "";
      description = "Additional mbsync configuration";
    };

    # Option to set how often mbsync should run
    frequency = mkOption {
      type = types.str;
      default = "*:0/5";
      description = "How often to run mbsync. Default is every 5 minutes.";
    };
  };

  # The actual configuration to apply when mbsync is enabled
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."mbsyncrc".text = ''
      # Default settings
      Create Both    # Create mailboxes if they don't exist on either side
      Expunge Both   # Delete messages on both sides if deleted on one side
      SyncState *    # Save sync state for all mailboxes

      # IMAP account configuration
      IMAPAccount personal
      Host mail.jonash.xyz
      User jonash@jonash.xyz
      PassCmd "pass email/jonash@jonash.xyz"  # Use 'pass' for secure password retrieval
      SSLType IMAPS  # Use SSL/TLS for secure connection

      # Remote storage (IMAP server)
      IMAPStore personal-remote
      Account personal

      # Local storage (where emails will be stored on your machine)
      MaildirStore personal-local
      Path ${maildir}/personal/
      Inbox ${maildir}/personal/INBOX
      SubFolders Verbatim

      # Channel - connects remote and local storage
      Channel personal
      Far :personal-remote:
      Near :personal-local:
      Patterns *  # Sync all folders

      # Include user's additional configuration
      ${cfg.configFile}
    '';

    systemd.user.services.mbsync = {
      description = "Mailbox synchronization service";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${maildir}/personal/INBOX";
        ExecStart = "${cfg.package}/bin/mbsync -a";  # Sync all channels
      };
    };

    systemd.user.timers.mbsync = {
      description = "Periodic mailbox synchronization";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnBootSec = "5m";  # Run 5 minutes after boot
        OnUnitActiveSec = cfg.frequency;  # Run at the specified frequency
        Unit = "mbsync.service";
      };
    };
  };
}
