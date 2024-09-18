{ config, pkgs, lib, ... }:

let
  username = "jonash";  # Replace with your actual username
  mwWrapper = pkgs.writeScriptBin "mw" ''
    #!${pkgs.stdenv.shell}
    export HOME="/home/${username}"
    export XDG_CONFIG_HOME="/home/${username}/.config"
    export XDG_DATA_HOME="/home/${username}/.local/share"
    export XDG_CACHE_HOME="/home/${username}/.cache"
    export MBSYNCRC="/home/${username}/.mbsyncrc"
    export NOTMUCH_CONFIG="/home/${username}/.notmuch-config"
    export PATH="${pkgs.mutt-wizard}/bin:$PATH"
    
    # Override the variables in the original mw script
    muttshare="$XDG_DATA_HOME/mutt-wizard"
    cachedir="$XDG_CACHE_HOME/mutt-wizard"
    muttrc="$XDG_CONFIG_HOME/mutt/muttrc"
    accdir="$XDG_CONFIG_HOME/mutt/accounts"
    mwconfig="$XDG_CONFIG_HOME/mw"

    exec ${pkgs.mutt-wizard}/bin/mw "$@"
  '';
in
{
  environment.systemPackages = [
    pkgs.mutt-wizard
    pkgs.neomutt
    pkgs.isync
    pkgs.msmtp
    pkgs.notmuch
    pkgs.pass
    mwWrapper
  ];

  system.activationScripts.muttWizardSetup = ''
    # Ensure necessary directories exist
    mkdir -p /home/${username}/.config/mutt
    mkdir -p /home/${username}/.config/neomutt
    mkdir -p /home/${username}/.local/share/mail
    mkdir -p /home/${username}/.local/share/mutt-wizard
    mkdir -p /home/${username}/.cache/mutt/{headers,bodies}
    mkdir -p /home/${username}/.cache/mutt-wizard
    mkdir -p /home/${username}/.config/mw
    mkdir -p /home/${username}/.mbsyncrc.d
    touch /home/${username}/.mbsyncrc
    touch /home/${username}/.notmuch-config
    touch /home/${username}/.config/mutt/muttrc

    # Set correct permissions
    chown -R ${username}:users /home/${username}/.config/mutt
    chown -R ${username}:users /home/${username}/.config/neomutt
    chown -R ${username}:users /home/${username}/.local/share/mail
    chown -R ${username}:users /home/${username}/.local/share/mutt-wizard
    chown -R ${username}:users /home/${username}/.cache/mutt
    chown -R ${username}:users /home/${username}/.cache/mutt-wizard
    chown -R ${username}:users /home/${username}/.config/mw
    chown ${username}:users /home/${username}/.mbsyncrc
    chown ${username}:users /home/${username}/.mbsyncrc.d
    chown ${username}:users /home/${username}/.notmuch-config
  '';

  environment.variables = {
    MUTT_WIZARD_CONFIG = "/home/${username}/.config/mw";
    MBSYNCRC = "/home/${username}/.mbsyncrc";
    NOTMUCH_CONFIG = lib.mkForce "/home/${username}/.notmuch-config";
  };
}
