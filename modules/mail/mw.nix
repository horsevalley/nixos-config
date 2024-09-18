{ config, pkgs, lib, ... }:

let
  username = "jonash";  # Replace with your actual username
in
{
  environment.systemPackages = [ pkgs.mutt-wizard pkgs.neomutt pkgs.isync pkgs.msmtp pkgs.notmuch pkgs.pass ];

  system.activationScripts.muttWizardSetup = ''
    # Ensure necessary directories exist
    mkdir -p /home/${username}/.config/mutt
    mkdir -p /home/${username}/.local/share/mail
    mkdir -p /home/${username}/.cache/mutt/{headers,bodies}
    mkdir -p /home/${username}/.config/mw
    mkdir -p /home/${username}/.mbsyncrc.d
    touch /home/${username}/.mbsyncrc
    touch /home/${username}/.notmuch-config

    # Set correct permissions
    chown -R ${username}:users /home/${username}/.config/mutt
    chown -R ${username}:users /home/${username}/.local/share/mail
    chown -R ${username}:users /home/${username}/.cache/mutt
    chown -R ${username}:users /home/${username}/.config/mw
    chown ${username}:users /home/${username}/.mbsyncrc
    chown ${username}:users /home/${username}/.mbsyncrc.d
    chown ${username}:users /home/${username}/.notmuch-config
  '';

  environment.variables = {
    MUTT_WIZARD_CONFIG = "/home/${username}/.config/mw";
    MBSYNCRC = "/home/${username}/.mbsyncrc";
    NOTMUCH_CONFIG = "/home/${username}/.notmuch-config";
  };

  # Patch mutt-wizard to use user-specific directories
  system.activationScripts.patchMuttWizard = ''
    patch_file=$(mktemp)
    cat > $patch_file << 'EOL'
    diff --git a/mw b/mw
    index a5c8d53..b5c2c70 100755
    --- a/mw
    +++ b/mw
    @@ -14,8 +14,8 @@ muttshare="${XDG_DATA_HOME:-$HOME/.local/share}/mutt-wizard"
     sslcerts="/etc/ssl/certs/ca-certificates.crt"
     cachedir="$HOME/.cache/mutt-wizard"
     muttrc="$muttshare/mutt-wizard.muttrc"
    -mbsyncrc="/mbsync/config"
    -notmuchrc="/notmuch-config"
    +mbsyncrc="${MBSYNCRC:-$HOME/.mbsyncrc}"
    +notmuchrc="${NOTMUCH_CONFIG:-$HOME/.notmuch-config}"
     muttrc="$HOME/.config/mutt/muttrc"
     accdir="$HOME/.config/mutt/accounts"
     mwconfig="$HOME/.config/mw"
    EOL

    patch ${pkgs.mutt-wizard}/bin/mw $patch_file
  '';

  # Create a wrapper script for mw
  environment.systemPackages = [
    (pkgs.writeScriptBin "mw" ''
      #!${pkgs.stdenv.shell}
      export HOME="/home/${username}"
      export XDG_CONFIG_HOME="/home/${username}/.config"
      export XDG_DATA_HOME="/home/${username}/.local/share"
      export XDG_CACHE_HOME="/home/${username}/.cache"
      exec ${pkgs.mutt-wizard}/bin/mw "$@"
    '')
  ];
}
