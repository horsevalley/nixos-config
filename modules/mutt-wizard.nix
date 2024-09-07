# This module configures mutt-wizard, a tool that automates the setup of neomutt along with other
# tools like isync (mbsync) for syncing, msmtp for sending, and notmuch for searching.
# It provides a simpler interface for managing multiple email accounts.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.mutt-wizard;
  
  # Helper function to safely get the first email or return a default
  getFirstEmail = emails:
    if builtins.length emails > 0
    then builtins.head emails
    else "jonash@jonash.xyz";  # Default email if the list is empty

  # Helper function to get all emails except the first one
  getOtherEmails = emails:
    if builtins.length emails > 1
    then builtins.tail emails
    else [];

in {
  options.programs.mutt-wizard = {
    enable = mkEnableOption "mutt-wizard for email configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.mutt-wizard;
      defaultText = literalExpression "pkgs.mutt-wizard";
      description = "The mutt-wizard package to use.";
    };

    accounts = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "A name for this account (used in file names)";
          };
          email = mkOption {
            type = types.str;
            description = "The email address for this account";
          };
          type = mkOption {
            type = types.enum [ "imap" "outlook" "gmail" "yahoo" ];
            description = "The type of email account";
          };
          imap = mkOption {
            type = types.str;
            description = "IMAP server address (if applicable)";
          };
          smtp = mkOption {
            type = types.str;
            description = "SMTP server address (if applicable)";
          };
          passwordCommand = mkOption {
            type = types.str;
            default = "";
            description = "Command to retrieve the account password (e.g., 'pass email/myaccount')";
          };
        };
      });
      default = [];
      description = "List of email accounts to configure";
    };

    sync = {
      enable = mkEnableOption "automatic email syncing";
      interval = mkOption {
        type = types.str;
        default = "*:0/5";
        description = "How often to sync emails. Default is every 5 minutes.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.package
      neomutt
      isync
      msmtp
      notmuch-mutt
      pass  # for password management
    ];

    # Create mutt-wizard configuration file
    environment.etc."mutt-wizard.json".text = builtins.toJSON {
      accounts = cfg.accounts;
    };

    # Set up mutt-wizard and configure accounts
    system.activationScripts.muttWizardSetup = ''
      # Ensure necessary directories exist
      mkdir -p ~/.config/mutt ~/.local/share/mail

      # Run mutt-wizard to set up accounts
      ${cfg.package}/bin/mw -a < /etc/mutt-wizard.json

      # Set up password retrieval for each account
      ${builtins.concatStringsSep "\n" (map (account: ''
        echo "${account.passwordCommand}" > ~/.config/mutt/accounts/${account.name}.passwordeval
      '') cfg.accounts)}
    '';

    # Set up automatic syncing if enabled
    systemd.user.services.mbsync = mkIf cfg.sync.enable {
      description = "Mailbox synchronization service";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.isync}/bin/mbsync -a";
      };
    };

    systemd.user.timers.mbsync = mkIf cfg.sync.enable {
      description = "Periodic mailbox synchronization";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = cfg.sync.interval;
        Unit = "mbsync.service";
      };
    };

    # Set up notmuch
    environment.etc."notmuch-config".text = ''
      [database]
      path=/home/jonash/.local/share/mail

      [user]
      name=Jonas Hestdahl
      primary_email=${getFirstEmail (map (a: a.email) cfg.accounts)}
      other_email=${builtins.concatStringsSep ";" (getOtherEmails (map (a: a.email) cfg.accounts))};

      [new]
      tags=unread;inbox;
      ignore=

      [search]
      exclude_tags=deleted;spam;

      [maildir]
      synchronize_flags=true

      [crypto]
      gpg_path=${pkgs.gnupg}/bin/gpg
    '';

    system.activationScripts.notmuchConfig = ''
      mkdir -p /home/jonash/.config
      ln -sf /etc/notmuch-config /home/jonash/.notmuch-config
    '';
  };
}
