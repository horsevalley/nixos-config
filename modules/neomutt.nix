{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.neomutt;
in {
  options.programs.neomutt = {
    enable = mkEnableOption "neomutt email client";

    package = mkOption {
      type = types.package;
      default = pkgs.neomutt;
      defaultText = literalExpression "pkgs.neomutt";
      description = "The neomutt package to use.";
    };

    configFile = mkOption {
      type = types.lines;
      default = "";
      description = "neomutt configuration";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional neomutt configuration";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."neomuttrc".text = ''
      # Basic Settings
      set editor = "nvim"
      set sort = threads
      set sort_aux = reverse-last-date-received
      set charset = "utf-8"

      # Sidebar Settings
      set sidebar_visible = yes
      set sidebar_width = 30
      set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
      set mail_check_stats

      # Mailboxes
      mailboxes =INBOX =Sent =Drafts =Trash =Junk

      # Account Settings
      source ~/.config/neomutt/accounts/personal

      # Key Bindings
      bind index,pager \CP sidebar-prev
      bind index,pager \CN sidebar-next
      bind index,pager \CO sidebar-open

      # Colors
      color normal default default
      color indicator brightblack white
      color status brightgreen blue
      color sidebar_highlight red default
      color sidebar_divider brightblack black

      # GPG settings
      set crypt_use_gpgme = yes
      set pgp_use_gpg_agent = yes
      set pgp_sign_as = 7FC814B3D47E2BA4154B9060259DB794215BE837 # Replace with your GPG key ID
      set crypt_autosign = yes
      set crypt_verify_sig = yes

      # Use msmtp for sending emails
      set sendmail = "/run/wrappers/bin/msmtp"

      ${cfg.configFile}
      ${cfg.extraConfig}
    '';
  };

  # Enable and configure the services
  programs.neomutt.enable = true;
  services.mbsync.enable = true;
  programs.msmtp.enable = true;

}
