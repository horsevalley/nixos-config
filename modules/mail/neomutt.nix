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
    # vim: filetype=neomuttrc
    # This file is a slightly modified version of Luke Smith's mutt-wizard.muttrc
    # https://raw.githubusercontent.com/LukeSmithxyz/mutt-wizard/master/share/mutt-wizard.muttrc

    # General Settings
    set mailcap_path = ~/.config/neomutt/mailcap
    set date_format="%y/%m/%d %I:%M%p"
    set index_format="%2C %Z %?X?A& ? %D %-15.15F %s (%-4.4c)"
    set markers = no
    set mark_old = no
    set mime_forward = yes
    set smtp_authenticators = 'gssapi:login'
    set wait_key = no
    set rfc2047_parameters = yes
    set sleep_time = 0
    set markers = no
    set mime_forward = yes
    set forward_format = "Fwd: %s"
    set forward_decode = yes
    set forward_quote = yes
    set reverse_name = yes
    set include = yes

    # Ensure TLS is enforced
    set ssl_starttls = yes
    set ssl_force_tls = yes

    # Sort by newest mail
    set sort = reverse-date-received

    auto_view text/html
    alternative_order text/plain text/enriched text/html

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
    set text_flowed
    set editor = "nvim"
    set sig_dashes = no
    set fast_reply = yes
    set sendmail_wait = 0
    set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"

    # Status Bar
    set status_chars  = " *%A"
    set status_format = "───[ Folder: %f ]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]───%>─%?p?( %p postponed )?───"

    # Key Bindings
    bind index,pager g noop
    bind index gg first-entry
    bind index G last-entry
    bind pager gg top
    bind pager G bottom
    bind index,pager \Cd half-down
    bind index,pager \Cu half-up
    bind index,pager N search-opposite
    bind index L limit
    bind pager L exit

    # Use Vim keys in menus
    bind generic,index,pager k previous-entry
    bind generic,index,pager j next-entry
    bind generic,index,pager \Ck previous-page
    bind generic,index,pager \Cj next-page
    bind generic,index,pager,browser gg first-entry
    bind generic,index,pager,browser G last-entry

    # Sidebar
    set sidebar_visible
    set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
    set mail_check_stats
    bind index,pager \CP sidebar-prev
    bind index,pager \CN sidebar-next
    bind index,pager \CO sidebar-open

    # Colors
    color index yellow default '.*'
    color index_author red default '.*'
    color index_number blue default
    color index_subject cyan default '.*'

    # For new mail:
    color index brightyellow black "~N"
    color index_author brightred black "~N"
    color index_subject brightcyan black "~N"

    color header blue default ".*"
    color header brightmagenta default "^(From)"
    color header brightcyan default "^(Subject)"
    color header brightwhite default "^(CC|BCC)"

    color quoted blue default
    color quoted1 cyan default
    color quoted2 yellow default
    color quoted3 red default
    color quoted4 brightred default

    color body brightcyan default "[;:]-*[)>(<lt;|]"
    color body brightcyan default "[ ][*][^*]*[*][ ]?"
    color body brightcyan default "[-+]>[-+]+"
    color body brightcyan default "[!?]{4,}"
    color body cyan default "\[[0-9]+\]"
    color body brightblue default "^ *-+$"
    color body brightgreen default "^[-_]=*$"
    color body yellow default "(^| )+(|[<>|])[a-zA-Z]{3,}(|[<>|])(|$)+"
    color body brightcyan default "(^| )+=(|[<>|])[a-zA-Z]{3,}(|[<>|])(|$)+"
    color body brightcyan default "(^| )+(|[<>|])[a-zA-Z]{3,}=(|[<>|])(|$)+"
    color body brightcyan default "=[a-zA-Z]{1,}="
    color body brightblue default "(^| )+\$[a-zA-Z]+:?$"
    color body brightblue default "(^|[[:space:]])\\$[a-zA-Z0-9]+"
    color body brightyellow default "(^| )+\`[^\`]+\`"
    color body brightblue default "(^| )+\\[a-zA-Z0-9]"
    color body brightblue default "(^|[[:space:]])@[a-zA-Z0-9]+"
    color body brightcyan default "^ {3,4}(#+)[ \t]+.*$"
    color body brightgreen default "^(#+)[ \t]+.*$"
    color body brightcyan default "([a-zA-Z]|[[:space:]])+://[^ ]+[^])"
    color body brightblue default "\\[[0-9]+\\]"

    color body red default "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+"
    color body brightblue default "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+"
    color attachment yellow default
    color signature brightgreen default
    color search brightmagenta default

    color indicator green default
    color error red default
    color message cyan default
    color status brightwhite default
    color tree white default
    color normal white default
    color tilde green default
    color bold cyan default
    color underline cyan default
    color markers brightcyan default

    # Vim-like macros
    macro index,pager gi "<change-folder>=INBOX<enter>" "go to inbox"
    macro index,pager gs "<change-folder>=Sent<enter>" "go to sent"
    macro index,pager gd "<change-folder>=Drafts<enter>" "go to drafts"
    macro index,pager gt "<change-folder>=Trash<enter>" "go to trash"
    macro index,pager gj "<change-folder>=Junk<enter>" "go to junk"

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
    text/plain; ${pkgs.vim}/bin/vim %s
    application/pdf; ${pkgs.zathura}/bin/zathura %s; test=test -n "$DISPLAY"
    image/*; ${pkgs.feh}/bin/feh %s; test=test -n "$DISPLAY"
    video/*; ${pkgs.mpv}/bin/mpv --quiet %s; test=test -n "$DISPLAY"
    audio/*; ${pkgs.mpv}/bin/mpv --quiet %s
    EOL

    # Set correct permissions
    chown -R ${username}:users /home/${username}/.config/neomutt
    chown -R ${username}:users /home/${username}/.local/share/mail
    chown -R ${username}:users /home/${username}/.cache/mutt
  '';
}
