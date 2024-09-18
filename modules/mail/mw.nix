{ pkgs, lib, config, ... }:

let
  mwScript = pkgs.writeTextFile {
    name = "mw-script";
    text = ''
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

      # Set the correct PASSWORD_STORE_DIR
      PASSWORD_STORE_DIR="/home/jonash/.local/share/password-store"

      alias mbsync='${pkgs.isync}/bin/mbsync -c "$mbsyncrc"'

      master="Far"
      slave="Near"

      sslcert="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"

      checkbasics() {
        command -v ${pkgs.gnupg}/bin/gpg >/dev/null 2>&1 && GPG="${pkgs.gnupg}/bin/gpg" || GPG="${pkgs.gnupg}/bin/gpg2"
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

      askinfo() {
        [ -z "$fulladdr" ] && echo "Give the full email address to add:" &&
          read -r fulladdr
        while ! echo "$fulladdr" | ${pkgs.gnugrep}/bin/grep -qE "^.+@.+\.[A-Za-z]+$"; do
          echo "$fulladdr is not a valid email address. Please retype the address:"
          read -r fulladdr
        done
        folder="$maildir/$fulladdr"
        getaccounts
        echo "$accounts" | ${pkgs.gnugrep}/bin/grep -q "\s$fulladdr$" 2>/dev/null &&
          { echo "$fulladdr has already been added" && exit 1; }
        { [ -z "$imap" ] || [ -z "$smtp" ]; } && parsedomains
        [ -z "$imap" ] && echo "Give your email server's IMAP address (excluding the port number):" &&
          read -r imap
        [ -z "$smtp" ] && echo "Give your email server's SMTP address (excluding the port number):" &&
          read -r smtp
        case $sport in
          587) tlsline="# tls_starttls" ;;
        esac
        [ -z "$realname" ] && realname="''${fulladdr%%@*}"
        [ -z "$passprefix" ] && passprefix=""
        hostname="''${fulladdr#*@}"
        login="''${login:-$fulladdr}"
        if [ -n "''${password+x}" ] && [ ! -f "$PASSWORD_STORE_DIR/$passprefix$fulladdr.gpg" ]; then
          insertpass
        elif [ ! -f "$PASSWORD_STORE_DIR/$passprefix$fulladdr.gpg" ]; then
          getpass
        fi
      }

      insertpass() {
        printf "%s" "$password" | ${pkgs.pass}/bin/pass insert -fe "$passprefix$fulladdr"
      }

      getpass() {
        while :; do
          ${pkgs.pass}/bin/pass rm -f "$passprefix$fulladdr" >/dev/null 2>&1
          ${pkgs.pass}/bin/pass insert -f "$passprefix$fulladdr" && break
        done
      }

      parsedomains() {
        serverinfo="$(${pkgs.gnugrep}/bin/grep "^''${fulladdr#*@}" "$muttshare/domains.csv" 2>/dev/null)"
        [ -z "$serverinfo" ] && serverinfo="$(${pkgs.gnugrep}/bin/grep "$(echo "''${fulladdr#*@}" | ${pkgs.gnused}/bin/sed "s/\.[^\.]*$/\.\\\*/")" "$muttshare/domains.csv" 2>/dev/null)"
        IFS=, read -r service imapsugg iportsugg smtpsugg sportsugg <<EOF
      $serverinfo
      EOF
        imap="''${imap:-$imapsugg}"
        smtp="''${smtp:-$smtpsugg}"
        sport="''${sport:-$sportsugg}"
        iport="''${iport:-$iportsugg}"
      }

      getboxes() {
        if [ -n "''${force+x}" ]; then
          mailboxes="$(printf "INBOX\\nDrafts\\nJunk\\nTrash\\nSent\\nArchive")"
        else
          info="$(${pkgs.curl}/bin/curl --location-trusted -s -m 5 --user "$login:$(${pkgs.pass}/bin/pass "$passprefix$fulladdr")" --url "''${protocol:-imaps}://$imap:''${iport:-993}")"
          [ -z "$info" ] && errorexit
          mailboxes="$(echo "$info" | ${pkgs.gnugrep}/bin/grep -v HasChildren | ${pkgs.gnused}/bin/sed "s/.*\" //;s/\"//g" | tr -d '\r')"
        fi
        [ "$type" = "pop" ] && mailboxes="INBOX"
        for x in $(
          ${pkgs.gnused}/bin/sed -n "/^macro.* i[0-9] / s/\(^macro.* i\| .*\)//gp " "$muttrc" 2>/dev/null | sort -u
          echo 0
        ); do
          idnum=$((idnum + 1))
          [ "$idnum" -eq "$x" ] || break
        done
        toappend="mailboxes $(echo "$mailboxes" | ${pkgs.gnused}/bin/sed "s/^/\"=/;s/$/\"/;s/'/\\\'/g" | ${pkgs.coreutils}/bin/paste -sd ' ' -)"
      }

      finalize() {
        echo "$toappend" >>"$accdir/$fulladdr.muttrc"
        [ "$type" != "online" ] && echo "$mailboxes" | ${pkgs.findutils}/bin/xargs -I {} ${pkgs.coreutils}/bin/mkdir -p "$maildir/$fulladdr/{}/cur" "$maildir/$fulladdr/{}/tmp" "$maildir/$fulladdr/{}/new"
        ${pkgs.coreutils}/bin/mkdir -p "$cachedir/$safename/bodies"
        echo "$fulladdr (account #$idnum) added successfully."
        return 0
      }

      # ... (other functions like delete, reorder, etc.)

      while getopts "rfpXlhodTYD:y:i:I:s:S:u:a:n:P:x:m:t:" o; do case "''${o}" in
        l) action="list" ;;
        r) action="reorder" ;;
        d) action="delete" ;;
        D) action="delete"; fulladdr="$OPTARG" ;;
        y) action="sync"; fulladdr="$OPTARG" ;;
        Y) action="sync" ;;
        a) action="add"; fulladdr="$OPTARG" ;;
        i) imap="$OPTARG" ;;
        I) iport="$OPTARG" ;;
        s) smtp="$OPTARG" ;;
        S) sport="$OPTARG" ;;
        u) login="$OPTARG" ;;
        n) realname="$OPTARG" ;;
        P) passprefix="$OPTARG" ;;
        x) password="$OPTARG" ;;
        p) type="pop"; protocol="pop3s"; iport="''${iport:-995}" ;;
        o) type="online" ;;
        f) force=True ;;
        X) purge=True ;;
        t) cronmin="$OPTARG" ;;
        T) action="toggle" ;;
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
          mailsync $fulladdr
          ;;
        toggle) togglecron ;;
        reorder) reorder ;;
        info) mwinfo ;;
        *) mwinfo; exit 1 ;;
      esac
    '';
    executable = true;
    destination = "/bin/mw";
  };

  mw = pkgs.symlinkJoin {
    name = "mw";
    paths = [ mwScript ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/mw \
        --prefix PATH : ${lib.makeBinPath [
          pkgs.mutt-wizard
          pkgs.neomutt
          pkgs.isync
          pkgs.msmtp
          pkgs.pass
          pkgs.gnupg
          pkgs.findutils
          pkgs.gnugrep
          pkgs.gnused
          pkgs.coreutils
          pkgs.curl
          pkgs.gawk
          pkgs.urlview
        ]}
    '';
  };

in {
  environment.systemPackages = [ mw ];
}
