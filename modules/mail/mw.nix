{ pkgs, lib, config, ... }:

let
  mw = pkgs.writeScriptBin "mw" ''
    #!${pkgs.stdenv.shell}

    set -a

    maildir="''${XDG_DATA_HOME:-$HOME/.local/share}/mail"
    muttshare="${pkgs.mutt-wizard}/share/mutt-wizard"
    cachedir="''${XDG_CACHE_HOME:-$HOME/.cache}/mutt-wizard"
    muttrc="''${XDG_CONFIG_HOME:-$HOME/.config}/mutt/muttrc"
    accdir="''${XDG_CONFIG_HOME:-$HOME/.config}/mutt/accounts"
    msmtprc="''${XDG_CONFIG_HOME:-$HOME/.config}/msmtp/config"
    msmtplog="''${XDG_STATE_HOME:-$HOME/.local/state}/msmtp/msmtp.log"
    mbsyncrc="''${MBSYNCRC:-$HOME/.mbsyncrc}"
    mpoprc="''${XDG_CONFIG_HOME:-$HOME/.config}/mpop/config"
    mpoptemp="$muttshare/mpop-temp"
    mbsynctemp="$muttshare/mbsync-temp"
    mutttemp="$muttshare/mutt-temp"
    msmtptemp="$muttshare/msmtp-temp"
    onlinetemp="$muttshare/online-temp"
    notmuchtemp="$muttshare/notmuch-temp"
    iport="993"
    sport="465"
    imapssl="IMAPS"
    tlsline="tls_starttls off"
    maxmes="0"

    alias mbsync='${pkgs.isync}/bin/mbsync -c "$mbsyncrc"'

    master="Far"
    slave="Near"

    sslcert="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"

    checkbasics() {
      command -V ${pkgs.gnupg}/bin/gpg >/dev/null 2>&1 && GPG="${pkgs.gnupg}/bin/gpg" || GPG="${pkgs.gnupg}/bin/gpg2"
      PASSWORD_STORE_DIR="''${PASSWORD_STORE_DIR:-$HOME/.password-store}"
      [ -r "$PASSWORD_STORE_DIR/.gpg-id" ] || {
        echo "First run \`pass init <yourgpgemail>\` to set up a password archive."
        echo "(If you don't already have a GPG key pair, first run \`$GPG --full-generate-key\`.)"
        exit 1
      }
    }

    getaccounts() { accounts="$(${pkgs.findutils}/bin/find -L "$accdir" -type f 2>/dev/null | ${pkgs.gnugrep}/bin/grep -o "\S*.muttrc" | ${pkgs.gnused}/bin/sed "s|.*/\([0-9]-\)*||;s/\.muttrc$//" | ${pkgs.coreutils}/bin/nl)"; }

    list() { getaccounts && [ -n "$accounts" ] && echo "$accounts" || exit 1; }

    mwinfo() {
      cat <<EOF
    mw: mutt-wizard, auto-configure email accounts for mutt
    including downloadable mail with \`isync\`.

    Main actions:
      -a your@email.com	Add an email address
      -l			List email addresses configured
      -d			Remove an already added address
      -D your@email.com	Force remove account without confirmation
      -t number		Toggle automatic mailsync every <number> minutes
      -T			Toggle automatic mailsync
      -r			Reorder account numbers

    Options allowed with -a:
      -u	Account login name if not full address
      -n	"Real name" to be on the email account
      -i	IMAP/POP server address
      -I	IMAP/POP server port
      -s	SMTP server address
      -S	SMTP server port
      -x	Password for account (recommended to be in double quotes)
      -p	Add for a POP server instead of IMAP.
      -P	Pass Prefix (prefix of the file where password is stored)
      -X	Delete an account's local email too when deleting.
      -o	Configure address, but keep mail online.
      -f	Assume typical English mailboxes without attempting log-on.

    NOTE: Once at least one account is added, you can run
    \`mbsync -a\` to begin downloading mail.

    To change an account's password, run \`pass edit '$passprefix'your@email.com\`.
    EOF
    }

    # ... (other functions like askinfo, insertpass, getpass, etc.)

    while getopts "rfpXlhodTYD:y:i:I:s:S:u:a:n:P:x:m:t:" o; do case "''${o}" in
      l) action="list" ;;
      r) action="reorder" ;;
      d) action="delete" ;;
      D) action="delete"; fulladdr="$OPTARG" ;;
      y) action="sync"; fulladdr="$OPTARG" ;;
      Y) action="sync" ;;
      a) action="add"; fulladdr="$OPTARG" ;;
      # ... (other cases)
      h) action="info" ;;
      *) echo "Invalid option. See \`mw -h\` for help."; exit 1 ;;
    esac done

    [ -z "$action" ] && action="info"

    case "$action" in
      list) list ;;
      add) checkbasics && askinfo && getboxes && getprofiles && finalize ;;
      delete) delete ;;
      sync)
        echo "\`mw -y\` and \`mw -Y\` are now deprecated and will be removed in a future update. Please switch to using \`mailsync\`."
        ${pkgs.writeScriptBin "mailsync" ''
          # ... (content of mailsync script)
        ''}/bin/mailsync $fulladdr
        ;;
      toggle) togglecron ;;
      reorder) reorder ;;
      info) mwinfo ;;
      *) mwinfo; exit 1 ;;
    esac
  '';
in {
  environment.systemPackages = [ mw ];
}
