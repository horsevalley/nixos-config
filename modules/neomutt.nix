{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.neomutt;
  maildir = "/home/jonash/.mail";  # Adjust this path as needed
in {
  options.programs.neomutt = {
    enable = mkEnableOption "neomutt email client";

    package = mkOption {
      type = types.package;
      default = pkgs.neomutt;
      defaultText = literalExpression "pkgs.neomutt";
      description = "The neomutt package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."neomuttrc".text = ''
      # Mailbox configuration
      set folder = "${maildir}"
      set spoolfile = "+INBOX"
      set record = "+Sent"
      set postponed = "+Drafts"
      set trash = "+Trash"

      mailboxes =INBOX =Sent =Drafts =Trash =Junk

      # Date format
      set date_format="%d/%m/%y %H:%M"

      # Index and sort format
      set index_format="%2C %Z %?X?A& ? %D %-15.15F %s (%-4.4c)"
      set sort = 'reverse-date'

      # Sidebar mappings
      set sidebar_visible = yes
      set sidebar_width = 20
      set sidebar_short_path = yes
      set sidebar_next_new_wrap = yes
      set mail_check_stats

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

      # Offlineimap bindings
      macro index,pager o "<shell-escape>offlineimap -q<enter>" "Run a quick sync with offlineimap"
      macro index,pager O "<shell-escape>offlineimap<enter>" "Run a full sync with offlineimap"

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
    '';

    # Create mailbox directories
    system.activationScripts.neomuttMaildir = ''
      mkdir -p ${maildir}/{INBOX,Sent,Drafts,Trash,Junk}
      chown -R jonash:users ${maildir}
    '';

    # Ensure neomutt uses the system-wide configuration
    environment.variables.NEOMUTT = "/etc/neomuttrc";
  };
}
