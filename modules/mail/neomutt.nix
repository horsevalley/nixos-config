{ config, pkgs, lib, ... }:

let
  username = "jonash";  # Replace with your actual username
in
{
  environment.systemPackages = [ pkgs.neomutt ];

  system.activationScripts.neomuttSetup = ''
    # Ensure XDG directories exist
    mkdir -p /home/${username}/.config/neomutt
    mkdir -p /home/${username}/.local/share/mail
    mkdir -p /home/${username}/.cache/mutt/{headers,bodies}
    
    # Create neomutt config file
    cat > /home/${username}/.config/neomutt/neomuttrc << EOL
    # Basic Settings
    set mailcap_path = ~/.config/neomutt/mailcap
    set date_format="%y/%m/%d %I:%M%p"
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

    # Vim-like keybindings
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
    set sidebar_visible
    set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
    set mail_check_stats
    bind index,pager \CP sidebar-prev
    bind index,pager \CN sidebar-next
    bind index,pager \CO sidebar-open

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
    macro index,pager ga "<change-folder>=Archive<enter>" "go to archive"
    macro index,pager gs "<change-folder>=Sent<enter>" "go to sent"
    macro index,pager gd "<change-folder>=Drafts<enter>" "go to drafts"
    macro index,pager gt "<change-folder>=Trash<enter>" "go to trash"

    # Account Settings
    set realname = "Jonash"
    set from = "jonash@jonash.xyz"
    set use_from = yes
    set envelope_from = yes

    # Paths
    set folder = "~/.local/share/mail"
    set header_cache = "~/.cache/mutt/headers"
    set message_cachedir = "~/.cache/mutt/bodies"
    set certificate_file = "~/.config/neomutt/certificates"
    set mailcap_path = "~/.config/neomutt/mailcap"
    set tmpdir = "~/.cache/mutt/tmp"

    # Mailboxes
    mailboxes =jonash@jonash.xyz/INBOX =jonash@jonash.xyz/Sent =jonash@jonash.xyz/Drafts =jonash@jonash.xyz/Trash =jonash@jonash.xyz/Archive

    # Hook to set the correct From address when replying
    reply-hook . 'set from="jonash@jonash.xyz"'
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
