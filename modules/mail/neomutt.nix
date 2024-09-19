{ config, pkgs, lib, ... }:

let
  username = "jonash";  # Replace with your actual username
  email = "jonash@jonash.xyz";  # Replace with your actual email
in
{
  environment.systemPackages = with pkgs; [
    neomutt
    lynx
    zathura
    # feh
    # poppler_utils  # For pdftotext
    isync  # For mbsync
    msmtp
    pass
    notmuch
    xdg-utils # for xdg-open
  ];

  system.activationScripts.neomuttSetup = ''
    # Ensure XDG directories exist
    mkdir -p /home/${username}/.config/neomutt
    mkdir -p /home/${username}/.local/share/mail/${email}
    mkdir -p /home/${username}/.cache/mutt/{headers,bodies}
    
    # Create neomutt config file
    cat > /home/${username}/.config/neomutt/neomuttrc << EOL

    # Basic Settings
    set mailcap_path = ~/.config/neomutt/mailcap
    set date_format="%A %d %m %y %H:%M"
    set index_format="%2C %Z %?X?A& ? %D %-15.15F %s (%-4.4c)"
    set sort = 'reverse-date'
    set sort_aux = 'reverse-last-date-received'
    set uncollapse_jump
    set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"
    set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
    set send_charset = "utf-8"
    set charset = "utf-8"
    set editor = "vim"

    # Vim-like keybindings
    bind index,pager g noop
    bind index,pager i noop
    bind index \Cf noop
    bind index,pager M noop
    bind index,pager C noop
    bind index gg first-entry
    bind index G last-entry
    bind pager gg top
    bind pager G bottom
    bind index,pager \Cd half-down
    bind index,pager \Cu half-up
    bind index,pager N search-opposite
    bind index L limit
    bind pager L exit
    bind attach <return> view-mailcap
    bind attach l view-mailcap

    # Use Vim keys in menus
    bind generic,index,pager k previous-entry
    bind generic,index,pager j next-entry
    bind generic,index,pager \Ck previous-page
    bind generic,index,pager \Cj next-page
    bind generic,index,pager,browser gg first-entry
    bind generic,index,pager,browser G last-entry
    bind index D delete-message
    bind index U undelete-message
    bind index,pager,browser d half-down
    bind index,pager,browser u half-up
    bind index,pager S sync-mailbox
    bind index,pager R group-reply

    # Pager View Options
    set pager_stop
    set menu_scroll
    set tilde
    unset markers

    # General rebindings
    bind index gg first-entry
    bind index j next-entry
    bind index k previous-entry
    bind attach <return> view-mailcap
    bind attach l view-mailcap
    bind editor <space> noop
    bind index G last-entry
    bind pager,attach h exit
    bind pager j next-line
    bind pager k previous-line
    bind pager l view-attachments
    bind index D delete-message
    bind index U undelete-message
    bind index L limit
    bind index h noop
    bind index l display-message
    bind index,query <space> tag-entry
    macro browser h '<change-dir><kill-line>..<enter>' "Go to parent folder"
    bind index,pager H view-raw-message
    bind browser l select-entry
    bind browser gg top-page
    bind browser G bottom-page
    bind pager gg top
    bind pager G bottom
    bind index,pager,browser d half-down
    bind index,pager,browser u half-up
    bind index,pager S sync-mailbox
    bind index,pager R group-reply
    bind index \031 previous-undeleted	# Mouse wheel
    bind index \005 next-undeleted		# Mouse wheel
    bind pager \031 previous-line		# Mouse wheel
    bind pager \005 next-line		# Mouse wheel
    bind editor <Tab> complete-query

    # Email Headers
    ignore *
    unignore from: to: cc: date: subject:
    unhdr_order *
    hdr_order from: to: cc: date: subject:

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
    set wait_key = no	                   # mutt won't ask "press key to continue"
    set include                          # include message in replies
    set forward_quote                    # include message in forwards
    set mail_check=60                    # to avoid lags using IMAP with some email providers (yahoo for example)
    auto_view text/html		               # automatically show html (mailcap uses lynx)
    auto_view application/pgp-encrypted
    alternative_order text/plain text/enriched text/html

    # Sidebar
    set sidebar_visible = no
    set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
    set mail_check_stats
    bind index,pager \CP sidebar-prev
    bind index,pager \CN sidebar-next
    bind index,pager \CO sidebar-open
    bind index,pager B sidebar-toggle-visible

    # Colors
    # Default index colors:
    color index_number blue default
    color index blue default '.*'
    color index_author brightblue default '.*'
    color index_subject brightblue default '.*'

    # New mail is boldened:
    color index brightwhite default "~N"
    color index_author brightwhite default "~N"
    color index_subject brightwhite default "~N"

    # Tagged mail is highlighted:
    color index brightyellow blue "~T"
    color index_author brightred blue "~T"
    color index_subject brightcyan blue "~T"

    # Flagged mail is highlighted:
    color index brightgreen default "~F"
    color index_subject brightgreen default "~F"
    color index_author brightgreen default "~F"

    # Other colors and aesthetic settings:
    mono bold bold
    mono underline underline
    mono indicator reverse
    mono error bold
    color normal default default
    color indicator brightblack blue
    color sidebar_highlight red default
    color sidebar_divider brightblack black
    color sidebar_flagged red black
    color sidebar_new green black
    color error red default
    color tilde black default
    color message cyan default
    color markers red white
    color attachment white default
    color search brightmagenta default
    color status bold brightblack blue
    color hdrdefault brightgreen default
    color quoted green default
    color quoted1 blue default
    color quoted2 cyan default
    color quoted3 yellow default
    color quoted4 red default
    color quoted5 brightred default
    color signature brightgreen default
    color bold black default
    color underline black default

    # Vim-like macros
    macro index,pager gi "<change-folder>=INBOX<enter>" "go to inbox"
    macro index,pager gs "<change-folder>=Sent<enter>" "go to sent"
    macro index,pager gd "<change-folder>=Drafts<enter>" "go to drafts"
    macro index,pager gt "<change-folder>=Trash<enter>" "go to trash"
    macro index,pager gj "<change-folder>=Junk<enter>" "go to junk"
    macro index,pager O "<shell-escape>mbsync -a<enter>" "run mbsync to sync all mail"

    macro index,pager Mi ";<save-message>=INBOX<enter>" "move mail to inbox"
    macro index,pager Ci ";<copy-message>=INBOX<enter>" "copy mail to inbox"
    macro index,pager Md ";<save-message>=Drafts<enter>" "move mail to drafts"
    macro index,pager Cd ";<copy-message>=Drafts<enter>" "copy mail to drafts"
    macro index,pager Mj ";<save-message>=Junk<enter>" "move mail to junk"
    macro index,pager Cj ";<copy-message>=Junk<enter>" "copy mail to junk"
    macro index,pager Mt ";<save-message>=Trash<enter>" "move mail to trash"
    macro index,pager Ct ";<copy-message>=Trash<enter>" "copy mail to trash"
    macro index,pager Ms ";<save-message>=Sent<enter>" "move mail to sent"
    macro index,pager Cs ";<copy-message>=Sent<enter>" "copy mail to sent"

    # Account Settings
    set realname = "Jonas Hestdahl"
    set from = "${email}"
    set use_from = yes
    set envelope_from = yes

    # Paths
    set folder = "~/.local/share/mail/${email}"
    set spoolfile = "+INBOX"
    set postponed = "+Drafts"
    set record = "+Sent"
    set trash = "+Trash"
    set header_cache = "~/.cache/mutt/headers"
    set message_cachedir = "~/.cache/mutt/bodies"
    set certificate_file = "~/.config/neomutt/certificates"
    set mailcap_path = "~/.config/neomutt/mailcap"
    set tmpdir = "~/.cache/mutt/tmp"

    # Mailboxes
    named-mailboxes "Inbox" =INBOX
    named-mailboxes "Sent" =Sent
    named-mailboxes "Drafts" =Drafts
    named-mailboxes "Trash" =Trash
    named-mailboxes "Junk" =Junk

    # Hook to set the correct From address when replying
    reply-hook . 'set from="${email}"'
    EOL

    # Create mailcap file
    cat > /home/${username}/.config/neomutt/mailcap << EOL
    text/html; ${pkgs.lynx}/bin/lynx -dump -force_html %s; copiousoutput; description=HTML Text; nametemplate=%s.html
    application/pdf; ${pkgs.xdg-utils}/bin/xdg-open %s; needsterminal
    image/*; ${pkgs.xdg-utils}/bin/xdg-open %s; needsterminal
    EOL

    cat >> /home/${username}/.config/neomutt/neomuttrc << EOL
    # Send notification for new emails
    set new_mail_command="notify-send 'New Email' '%n new messages, %u unread.' &"
    EOL

    # Set correct permissions
    chown -R ${username}:users /home/${username}/.config/neomutt
    chown -R ${username}:users /home/${username}/.local/share/mail
    chown -R ${username}:users /home/${username}/.cache/mutt
  '';

  # Configure isync (mbsync)
  environment.etc."mbsyncrc".text = ''
    IMAPAccount ${email}
    Host mail.jonash.xyz
    User ${email}
    PassCmd "pass email/${email}"
    SSLType IMAPS

    IMAPStore ${email}-remote
    Account ${email}

    MaildirStore ${email}-local
    Path ~/.local/share/mail/${email}/
    Inbox ~/.local/share/mail/${email}/INBOX
    SubFolders Verbatim

    Channel ${email}
    Far :${email}-remote:
    Near :${email}-local:
    Patterns *
    Create Both
    Expunge Both
    SyncState *
  '';

  # Configure msmtp
  environment.etc."msmtprc".text = ''
    account ${email}
    host mail.jonash.xyz
    port 587
    from ${email}
    user ${email}
    passwordeval "pass email/${email}"
    auth on
    tls on
    tls_trust_file /etc/ssl/certs/ca-certificates.crt

    account default : ${email}
  '';

  # # Systemd service for mbsync
  # systemd.user.services.mbsync = {
  #   description = "Mailbox synchronization service";
  #   after = [ "network.target" ];
  #   wantedBy = [ "default.target" ];
  #
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.isync}/bin/mbsync -a";
  #     Restart = "on-failure";
  #     RestartSec = "2m";
  #   };
  # };
  #
  # systemd.user.timers.mbsync = {
  #   description = "Periodic mailbox synchronization";
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     OnBootSec = "2m";
  #     OnUnitActiveSec = "2m";
  #     Unit = "mbsync.service";
  #   };
  # };
}
