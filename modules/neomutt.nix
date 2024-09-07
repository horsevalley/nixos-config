# This module configures neomutt, a powerful, terminal-based email client.
# It's part of a larger email setup including isync for syncing and msmtp for sending.

{ config, lib, pkgs, ... }:

with lib;

let
  # This lets us refer to the user's neomutt configuration options easily
  cfg = config.programs.neomutt;
  # Define the base mail directory (same as in isync.nix)
  maildir = "~/.mail";
in {
  options.programs.neomutt = {
    # Option to enable or disable neomutt
    enable = mkEnableOption "neomutt email client";

    # Option to specify which neomutt package to use
    package = mkOption {
      type = types.package;
      default = pkgs.neomutt;
      defaultText = literalExpression "pkgs.neomutt";
      description = "The neomutt package to use.";
    };

    # Option for additional neomutt configuration
    configFile = mkOption {
      type = types.lines;
      default = "";
      description = "Additional neomutt configuration";
    };

    # Option for any extra configuration that doesn't fit elsewhere
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Any extra neomutt configuration";
    };
  };

  # The actual configuration to apply when neomutt is enabled
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."neomuttrc".text = ''
      # Basic Settings
      set editor = "nvim"  # Use neovim as the default editor
      set sort = threads   # Sort emails by thread
      set sort_aux = reverse-last-date-received  # Sort threads by date
      set charset = "utf-8"  # Use UTF-8 encoding

      # Mail directory settings
      set folder = "${maildir}/personal"  # Set the base mail directory
      set spoolfile = "+INBOX"  # Set the default mailbox to open
      set record = "+Sent"     # Where to store sent messages
      set postponed = "+Drafts"  # Where to store draft messages
      set trash = "+Trash"     # Where to move deleted messages

      # Sidebar Settings
      set sidebar_visible = yes  # Show the sidebar
      set sidebar_width = 30     # Set sidebar width
      set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"  # Sidebar format
      set mail_check_stats  # Update mailbox statistics

      # Mailboxes to show in the sidebar
      mailboxes =INBOX =Sent =Drafts =Trash =Junk

      # Source account-specific settings
      source ~/.config/neomutt/accounts/personal

      # Key Bindings for sidebar navigation
      bind index,pager \CP sidebar-prev  # Ctrl-P to select previous mailbox
      bind index,pager \CN sidebar-next  # Ctrl-N to select next mailbox
      bind index,pager \CO sidebar-open  # Ctrl-O to open selected mailbox

      # Colors
      color normal default default
      color indicator brightblack white
      color status brightgreen blue
      color sidebar_highlight red default
      color sidebar_divider brightblack black

      # GPG settings for email encryption
      set crypt_use_gpgme = yes
      set pgp_use_gpg_agent = yes
      set pgp_sign_as = 7FC814B3D47E2BA4154B9060259DB794215BE837 # Replace with your GPG key ID
      set crypt_autosign = yes
      set crypt_verify_sig = yes

      # Use msmtp for sending emails
      set sendmail = "/run/wrappers/bin/msmtp"

      # Include user's additional configuration
      ${cfg.configFile}
      ${cfg.extraConfig}
    '';

    system.activationScripts = {
      neomuttConfig = {
        text = ''
          mkdir -p ~/.config/neomutt/accounts
        '';
        deps = [];
      };
    };
  };
}
