{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    mutt-wizard
    neomutt
    isync
    msmtp
    notmuch
    lynx
    w3m
    pass
    pinentry
  ];

  # Create necessary directories and files
  system.activationScripts = {
    muttWizardSetup = {
      deps = [];
      text = ''
        mkdir -p /home/jonash/.config/mutt
        touch /home/jonash/.config/mutt/muttrc
        mkdir -p /home/jonash/.local/share/mail
        mkdir -p /home/jonash/.config/mw
        chown -R jonash:users /home/jonash/.config/mutt
        chown -R jonash:users /home/jonash/.local/share/mail
        chown -R jonash:users /home/jonash/.config/mw
      '';
    };
  };

  # Set up mutt-wizard configuration
  environment.etc."mutt-wizard.muttrc".text = ''
    # Basic Settings
    set editor = "nvim"
    set sort = reverse-date
    set mailcap_path = ~/.config/mutt/mailcap

    # Sidebar Settings
    set sidebar_visible
    set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
    set mail_check_stats

    # Colors
    color normal        default             default
    color index         color4              default         "~N"
    color index         color1              default         "~F"
    color index         color13             default         "~T"
    color index         color1              default         "~D"
    color hdrdefault    color6              default
    color header        color4              default         "^Subject:"
    color body          color2              default         "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+"
    color body          color2              default         "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+"

    # Keybindings
    bind index,pager g noop
    macro index,pager gi "<change-folder>=INBOX<enter>" "go to inbox"
    macro index,pager ga "<change-folder>=Archive<enter>" "go to archive"
    macro index,pager gs "<change-folder>=Sent<enter>" "go to sent"
    macro index,pager gd "<change-folder>=Drafts<enter>" "go to drafts"
    macro index,pager gt "<change-folder>=Trash<enter>" "go to trash"

    # Source mutt-wizard configs
    source /home/jonash/.config/mutt/muttrc
  '';

  # Set up msmtp configuration
  environment.etc."msmtprc".text = ''
    # Set default values for all following accounts.
    defaults
    auth           on
    tls            on
    tls_trust_file /etc/ssl/certs/ca-certificates.crt
    logfile        ~/.msmtp.log

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

  # Set up mbsync configuration
  environment.etc."mbsyncrc".text = ''
    # jonash@jonash.xyz
    IMAPAccount jonash@jonash.xyz
    Host mail.jonash.xyz
    User jonash@jonash.xyz
    PassCmd "pass email/jonash@jonash.xyz"
    SSLType IMAPS
    CertificateFile /etc/ssl/certs/ca-certificates.crt

    IMAPStore jonash@jonash.xyz-remote
    Account jonash@jonash.xyz

    MaildirStore jonash@jonash.xyz-local
    Subfolders Verbatim
    Path /home/jonash/.local/share/mail/jonash@jonash.xyz/
    Inbox /home/jonash/.local/share/mail/jonash@jonash.xyz/INBOX

    Channel jonash@jonash.xyz
    Far :jonash@jonash.xyz-remote:
    Near :jonash@jonash.xyz-local:
    Patterns *
    Create Both
    Expunge Both
    SyncState *
  '';

  # Set up notmuch configuration
  environment.etc."notmuch-config".text = ''
    [database]
    path=/home/jonash/.local/share/mail

    [user]
    name=Jonash
    primary_email=jonash@jonash.xyz

    [new]
    tags=unread;inbox;
    ignore=

    [search]
    exclude_tags=deleted;spam;

    [maildir]
    synchronize_flags=true

    [crypto]
    gpg_path=gpg
  '';

  # Systemd service for mbsync
  systemd.user.services.mbsync = {
    description = "Mailbox synchronization service";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.isync}/bin/mbsync -a";
      Restart = "on-failure";
      RestartSec = "5m";
    };
  };

  systemd.user.timers.mbsync = {
    description = "Mailbox synchronization timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "mbsync.service";
    };
  };
}
