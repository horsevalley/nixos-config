{ config, pkgs, lib, ... }:

let
  username = "jonash";  # Replace with your actual username
  email = "jonash@jonash.xyz";  # Replace with your actual email
in
{
  environment.systemPackages = [ pkgs.neomutt ];

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
    set sort = 'threads'
    set sort_aux = 'reverse-last-date-received'
    set uncollapse_jump
    set sort_re
    set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"
    set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
    set send_charset = "utf-8"
    set charset = "utf-8"
    set editor = "vim"

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
    #bind browser h goto-parent
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
    set sidebar_visible = no
    set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
    set mail_check_stats
    bind index,pager \CP sidebar-prev
    bind index,pager \CN sidebar-next
    bind index,pager \CO sidebar-open
    bind index,pager B sidebar-toggle-visible

    # Colors
    color normal        default         default
    color index         color4          default         ~N # new messages
    color index         color1          default         ~F # flagged messages
    color index         color3          default         ~T # tagged messages
    color index         color1          default         ~D # deleted messages
    color body          color2          default         "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+" # URLs
    color body          color2          default         "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+" # email addresses
    color attachment    color5          default
    color signature     color8          default
    color search        color11         default

    # Vim-like macros
    macro index,pager gi "<change-folder>=INBOX<enter>" "go to inbox"
    macro index,pager gs "<change-folder>=Sent<enter>" "go to sent"
    macro index,pager gd "<change-folder>=Drafts<enter>" "go to drafts"
    macro index,pager gt "<change-folder>=Trash<enter>" "go to trash"
    macro index,pager gj "<change-folder>=Junk<enter>" "go to junk"
    macro index,pager O "<shell-escape>mailsync<enter>" "run mailsync to sync all mail"

    # Account Settings
    set realname = "Jonash"
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
    application/pdf; ${pkgs.zathura}/bin/zathura %s; test=test -n "$DISPLAY"
    image/*; ${pkgs.feh}/bin/feh %s; test=test -n "$DISPLAY"
    EOL

    # Set correct permissions
    chown -R ${username}:users /home/${username}/.config/neomutt
    chown -R ${username}:users /home/${username}/.local/share/mail
    chown -R ${username}:users /home/${username}/.cache/mutt
  '';
}
