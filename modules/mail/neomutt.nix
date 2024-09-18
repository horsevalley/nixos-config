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

    # General Settings
    set mailcap_path = ~/.config/neomutt/mailcap
    set date_format="%d/%m/%y %H:%M"
    set index_format="%2C %Z %?X?A& ? %D %-15.15F %s (%-4.4c)"
    set sort = 'reverse-date'
    set markers = no
    set mark_old = no
    set mime_forward = yes
    set smtp_authenticators = 'gssapi:login'
    set wait_key = no
    set rfc2047_parameters = yes
    set sleep_time = 0
    set markers = no

    # Ensure TLS is enforced
    set ssl_starttls = yes
    set ssl_force_tls = yes

    # Sidebar settings
    set sidebar_visible = no
    set sidebar_width = 20
    set sidebar_short_path = yes
    set sidebar_next_new_wrap = yes
    set mail_check_stats

    auto_view text/html
    alternative_order text/plain text/enriched text/html

    # Pager View Options
    set pager_index_lines = 10
    set pager_context = 3
    set pager_stop
    set menu_scroll
    set tilde
    unset markers

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

    # Sidebar bindings
    bind index,pager \CP sidebar-prev
    bind index,pager \CN sidebar-next
    bind index,pager \CO sidebar-open

    # AESTHETICS

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
    color indicator brightblack white
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
    color status brightwhite blue
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

    # Regex highlighting:
    color header brightmagenta default "^From"
    color header brightcyan default "^Subject"
    color header brightwhite default "^(CC|BCC)"
    color header blue default ".*"
    color body brightred default "[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+" # Email addresses
    color body brightblue default "(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+" # URL
    color body green default "\`[^\`]*\`" # Green text between ` and `
    color body brightblue default "^# \.*" # Headings as bold blue
    color body brightcyan default "^## \.*" # Subheadings as bold cyan
    color body brightgreen default "^### \.*" # Subsubheadings as bold green
    color body yellow default "^(\t| )*(-|\\*) \.*" # List items as yellow
    color body brightcyan default "[;:][-o][)/(|]" # emoticons
    color body brightcyan default "[;:][)(|]" # emoticons
    color body brightcyan default "[ ][*][^*]*[*][ ]?" # more emoticon?
    color body brightcyan default "[ ]?[*][^*]*[*][ ]" # more emoticon?
    color body red default "(BAD signature)"
    color body cyan default "(Good signature)"
    color body brightblack default "^gpg: Good signature .*"
    color body brightyellow default "^gpg: "
    color body brightyellow red "^gpg: BAD signature from.*"
    mono body bold "^gpg: Good signature"
    mono body bold "^gpg: BAD signature from.*"
    color body red default "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"

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
