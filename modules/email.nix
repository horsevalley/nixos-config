{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    neomutt
    isync
    msmtp
    notmuch
    lynx
    w3m
  ];

  # Isync (mbsync) configuration
  environment.etc."mbsyncrc".text = ''
    IMAPAccount jonash
    Host mail.jonash.xyz
    User jonash@jonash.xyz
    PassCmd "pass email/jonash@jonash.xyz"
    SSLType IMAPS
    CertificateFile /etc/ssl/certs/ca-certificates.crt

    IMAPStore jonash-remote
    Account jonash

    MaildirStore jonash-local
    Path ~/Mail/
    Inbox ~/Mail/INBOX
    SubFolders Verbatim

    Channel jonash
    Far :jonash-remote:
    Near :jonash-local:
    Patterns *
    Create Both
    Expunge Both
    SyncState *
  '';

  # msmtp configuration
  environment.etc."msmtprc".text = ''
    defaults
    auth on
    tls on
    tls_trust_file /etc/ssl/certs/ca-certificates.crt
    logfile ~/.msmtp.log

    account jonash
    host mail.jonash.xyz
    port 587
    from jonash@jonash.xyz
    user jonash@jonash.xyz
    passwordeval "pass email/jonash@jonash.xyz"

    account default : jonash
  '';

  # Neomutt configuration
  environment.etc."neomuttrc".text = ''
    # Account Settings
    set realname = "Jonash"
    set from = "jonash@jonash.xyz"
    set use_from = yes
    set envelope_from = yes

    # Paths
    set folder = "~/Mail"
    set header_cache = "~/.cache/mutt/headers"
    set message_cachedir = "~/.cache/mutt/bodies"
    set certificate_file = "~/.mutt/certificates"
    set mailcap_path = "~/.mutt/mailcap"
    set tmpdir = "~/.mutt/tmp"

    # Basic Options
    set wait_key = no
    set mbox_type = Maildir
    set timeout = 3
    set mail_check = 0
    unset move
    set delete
    unset confirmappend
    set quit
    unset mark_old
    set pipe_decode
    set thorough_search

    # Compose View Options
    set envelope_from                    # which from?
    set edit_headers                     # show headers when composing
    set fast_reply                       # skip to compose when replying
    set askcc                            # ask for CC:
    set fcc_attach                       # save attachments with the body
    set forward_format = "Fwd: %s"       # format of subject when forwarding
    set forward_decode                   # decode when forwarding
    set attribution = "On %d, %n wrote:" # format of quoting header
    set reply_to                         # reply to Reply to: field
    set reverse_name                     # reply as whomever it was to
    set include                          # include message in replies
    set forward_quote                    # include message in forwards

    # Sidebar
    set sidebar_visible = yes
    set sidebar_width = 20
    set sidebar_short_path = yes
    set sidebar_next_new_wrap = yes
    set mail_check_stats
    set sidebar_format = '%B%?F? [%F]?%* %?N?%N/?%S'

    # Status Bar
    set status_chars = " *%A"
    set status_format = "───[ Folder: %f ]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]───%>─%?p?( %p postponed )?───"

    # Index View Options
    set date_format = "%d.%m.%Y %H:%M"
    set index_format = "[%Z] %?X?A&-? %D  %-20.20F  %s"
    set sort = threads
    set sort_aux = reverse-last-date-received
    set uncollapse_jump
    set sort_re
    set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"
    set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
    set send_charset = "utf-8:iso-8859-1:us-ascii"
    set charset = "utf-8"

    # Pager View Options
    set pager_index_lines = 10
    set pager_context = 3
    set pager_stop
    set menu_scroll
    set tilde
    unset markers

    # Email Headers
    ignore *
    unignore from: to: cc: date: subject:
    unhdr_order *
    hdr_order from: to: cc: date: subject:

    # Attachments
    set attach_format = "[%D %t] %2n [%-7.7m/%10.10M] %.40d %> [%s] "

    # Keybindings
    bind index,pager g noop
    macro index,pager gi "<change-folder>=INBOX<enter>" "go to inbox"
    macro index,pager ga "<change-folder>=Archive<enter>" "go to archive"
    macro index,pager gs "<change-folder>=Sent<enter>" "go to sent"
    macro index,pager gd "<change-folder>=Drafts<enter>" "go to drafts"
    macro index,pager gt "<change-folder>=Trash<enter>" "go to trash"

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
  '';

  # Create necessary directories
  system.activationScripts = {
    neomuttSetup = {
      deps = [];
      text = ''
        mkdir -p /home/jonash/Mail
        mkdir -p /home/jonash/.cache/mutt/headers
        mkdir -p /home/jonash/.cache/mutt/bodies
        mkdir -p /home/jonash/.mutt/certificates
        mkdir -p /home/jonash/.mutt/tmp
        chown -R jonash:users /home/jonash/Mail
        chown -R jonash:users /home/jonash/.cache/mutt
        chown -R jonash:users /home/jonash/.mutt
      '';
    };
  };

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
