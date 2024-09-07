# This module configures notmuch, a fast, tag-based email indexer and searcher,
# and notmuch-mutt, which integrates notmuch with the mutt/neomutt email client.
# It's part of a larger email setup including neomutt for reading, isync for syncing, and msmtp for sending.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.notmuch;
  maildir = "~/.mail";  # Ensure this matches the maildir in your isync.nix
in {
  options.programs.notmuch = {
    enable = mkEnableOption "notmuch email indexer and searcher";

    package = mkOption {
      type = types.package;
      default = pkgs.notmuch;
      defaultText = literalExpression "pkgs.notmuch";
      description = "The notmuch package to use.";
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = "Additional configuration for notmuch.";
    };

    hooks = {
      preNew = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to run before running notmuch new.";
      };

      postNew = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to run after running notmuch new.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.package
      notmuch-mutt
    ];

    programs.neomutt.extraConfig = ''
      # Notmuch configuration for neomutt
      set nm_default_uri = "notmuch://${maildir}"
      set virtual_spoolfile = yes
      
      # Notmuch bindings
      macro index,pager \Cf "<enter-command>unset wait_key<enter><shell-escape>notmuch-mutt -r --prompt search<enter><change-folder-readonly>`echo ${maildir}/.cache/notmuch/mutt/results`<enter>" "search mail (notmuch)"
      macro index,pager \Cl "<enter-command>unset wait_key<enter><pipe-message>notmuch-mutt thread<enter><change-folder-readonly>`echo ${maildir}/.cache/notmuch/mutt/results`<enter><enter-command>set wait_key<enter>" "search and reconstruct owning thread (notmuch)"
      macro index,pager \Cx "<enter-command>unset wait_key<enter><pipe-message>notmuch-mutt tag -inbox<enter>" "remove message from inbox (notmuch)"
    '';

    home.file.".notmuch-config".text = ''
      [database]
      path=${maildir}

      [user]
      name=Jonas Hestdahl
      primary_email=jonash@jonash.xyz
      other_email=hestdahl@gmail.com;

      [new]
      tags=unread;inbox;
      ignore=

      [search]
      exclude_tags=deleted;spam;

      [maildir]
      synchronize_flags=true

      [crypto]
      gpg_path=${pkgs.gnupg}/bin/gpg

      ${builtins.concatStringsSep "\n" (mapAttrsToList (name: value: 
        "[${name}]\n" + builtins.concatStringsSep "\n" (mapAttrsToList (subName: subValue: "${subName}=${subValue}") value)
      ) cfg.extraConfig)}
    '';

    systemd.user.services.notmuch = {
      description = "Notmuch email indexer";
      after = [ "mbsync.service" ];
      wantedBy = [ "default.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "notmuch-update" ''
          ${cfg.hooks.preNew}
          ${cfg.package}/bin/notmuch new
          ${cfg.hooks.postNew}
        ''}";
      };
    };

    systemd.user.timers.notmuch = {
      description = "Periodic notmuch email indexing";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "5m";
        Unit = "notmuch.service";
      };
    };
  };
}
