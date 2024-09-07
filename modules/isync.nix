{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mbsync;
in {
  options.services.mbsync = {
    enable = mkEnableOption "mbsync email synchronization";

    package = mkOption {
      type = types.package;
      default = pkgs.isync;
      defaultText = literalExpression "pkgs.isync";
      description = "The isync package to use.";
    };

    configFile = mkOption {
      type = types.lines;
      default = "";
      description = "mbsync configuration";
    };

    frequency = mkOption {
      type = types.str;
      default = "*:0/5";
      description = "How often to run mbsync. Default is every 5 minutes.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."mbsyncrc".text = ''
      # Default settings
      Create Both
      Expunge Both
      SyncState *

      # IMAP account
      IMAPAccount personal
      Host mail.jonash.xyz
      User jonash@jonash.xyz
      PassCmd "pass email/jonash@jonash.xyz"
      SSLType IMAPS

      # Remote storage
      IMAPStore personal-remote
      Account personal

      # Local storage
      MaildirStore personal-local
      Path ~/.mail/personal/
      Inbox ~/.mail/personal/INBOX
      SubFolders Verbatim

      # Channel - connects remote and local
      Channel personal
      Far :personal-remote:
      Near :personal-local:
      Patterns *

      ${cfg.configFile}
    '';

    systemd.user.services.mbsync = {
      description = "Mailbox synchronization service";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${cfg.package}/bin/mbsync -a";
      };
    };

    systemd.user.timers.mbsync = {
      description = "Periodic mailbox synchronization";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = cfg.frequency;
        Unit = "mbsync.service";
      };
    };
  };
}
