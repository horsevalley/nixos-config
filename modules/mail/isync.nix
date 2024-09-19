{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.isync ];

  environment.etc."mbsyncrc".text = ''
    IMAPStore jonash-remote
    Host mail.jonash.xyz
    Port 993
    User jonash@jonash.xyz
    PassCmd "pass email/jonash@jonash.xyz"
    SSLType IMAPS
    CertificateFile /etc/ssl/certs/ca-certificates.crt

    MaildirStore jonash-local
    Subfolders Verbatim
    Path /home/jonash/.local/share/mail/jonash@jonash.xyz/
    Inbox /home/jonash/.local/share/mail/jonash@jonash.xyz/INBOX

    Channel jonash
    Far :jonash-remote:
    Near :jonash-local:
    Patterns *
    Create Both
    Expunge Both
    SyncState *
  '';

  systemd.user.services.mbsync = {
    description = "Mailbox synchronization service";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.isync}/bin/mbsync -a";
      Restart = "on-failure";
      RestartSec = "2m";
    };
  };

  systemd.user.timers.mbsync = {
    description = "Periodic mailbox synchronization";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "mbsync.service";
    };
  };
}
