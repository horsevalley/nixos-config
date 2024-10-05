{ config, lib, pkgs, ... }:
let
  urlHandler = pkgs.writeScriptBin "newsboat-url-handler" ''
    # ... (your existing urlHandler script)
  '';

  newsboatConfig = ''
    # ... (your existing newsboatConfig)
  '';

  # Read the urls file content
  urlsContent = builtins.readFile ./urls;

in
{
  config = {
    environment.systemPackages = [ pkgs.newsboat ];
    environment.etc."newsboat/config".text = newsboatConfig;
    environment.etc."newsboat/urls".text = urlsContent;
    system.activationScripts.newsboat-config = ''
      mkdir -p /home/jonash/.config/newsboat
      cp /etc/newsboat/config /home/jonash/.config/newsboat/config
      cp /etc/newsboat/urls /home/jonash/.config/newsboat/urls
      chown -R jonash:users /home/jonash/.config/newsboat
    '';
  };
}
