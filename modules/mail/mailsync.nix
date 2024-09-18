{ pkgs, lib, config, ... }:

let
  mailsync = pkgs.writeScriptBin "mailsync" ''
    #!${pkgs.stdenv.shell}

    # Run only if not already running in other instance
    ${pkgs.procps}/bin/pgrep mbsync >/dev/null && { echo "mbsync is already running."; exit ;}

    export GPG_TTY="$(tty)"

    [ -n "$MBSYNCRC" ] && alias mbsync="${pkgs.isync}/bin/mbsync -c $MBSYNCRC" || MBSYNCRC="$HOME/.mbsyncrc"
    [ -n "$MPOPRC" ] || MPOPRC="''${XDG_CONFIG_HOME:-$HOME/.config}/mpop/config"

    lastrun="''${XDG_CONFIG_HOME:-$HOME/.config}/mutt/.mailsynclastrun"

    notify() {
      ${pkgs.libnotify}/bin/notify-send --app-name="mutt-wizard" "$1" "$2"
    }

    syncandnotify() {
      case "$1" in
        imap) ${pkgs.isync}/bin/mbsync -q "$2" ;;
        pop) ${pkgs.mpop}/bin/mpop -q "$2" ;;
      esac
      new=$(${pkgs.findutils}/bin/find \
        "$HOME/.local/share/mail/$2/"[Ii][Nn][Bb][Oo][Xx]/new/ \
        "$HOME/.local/share/mail/$2/"[Ii][Nn][Bb][Oo][Xx]/cur/ \
        -type f -newer "$lastrun" 2> /dev/null)
      newcount=$(echo "$new" | ${pkgs.gnused}/bin/sed '/^\s*$/d' | ${pkgs.coreutils}/bin/wc -l)
      case 1 in
        $((newcount > 5)) )
          echo "$newcount new mail for $2."
          [ -z "$MAILSYNC_MUTE" ] && notify "New Mail!" "📬 $newcount new mail(s) in \`$2\` account."
          ;;
        $((newcount > 0)) )
          echo "$newcount new mail for $2."
          [ -z "$MAILSYNC_MUTE" ] &&
          for file in $new; do
            subject="$(${pkgs.gnused}/bin/sed -n "/^Subject:/ s|Subject: *|| p" "$file" |
              ${pkgs.perl}/bin/perl -CS -MEncode -ne 'print decode("MIME-Header", $_)')"
            from="$(${pkgs.gnused}/bin/sed -n "/^From:/ s|From: *|| p" "$file" |
              ${pkgs.perl}/bin/perl -CS -MEncode -ne 'print decode("MIME-Header", $_)')"
            from="''${from% *}" ; from="''${from%\"}" ; from="''${from#\"}"
            notify "📧$from:" "$subject"
          done
          ;;
        *) echo "No new mail for $2." ;;
      esac
    }

    allaccounts="$(${pkgs.gnugrep}/bin/grep -hs "^\(Channel\|account\)" "$MBSYNCRC" "$MPOPRC")"

    # Get accounts to sync
    IFS='
    '
    if [ -z "$1" ]; then
      tosync="$allaccounts"
    else
      tosync="$(for arg in "$@"; do for availacc in $allaccounts; do
        [ "$arg" = "''${availacc##* }" ] && echo "$availacc" && break
      done || echo "error $arg"; done)"
    fi

    for account in $tosync; do
      case $account in
        Channel*) syncandnotify imap "''${account##* }" & ;;
        account*) syncandnotify pop "''${account##* }" & ;;
        error*) echo "ERROR: Account ''${account##* } not found." ;;
      esac
    done

    wait

    ${pkgs.notmuch}/bin/notmuch new --quiet

    # Create a touch file that indicates the time of the last run of mailsync
    ${pkgs.coreutils}/bin/touch "$lastrun"
  '';
in {
  environment.systemPackages = [ mailsync ];
}
