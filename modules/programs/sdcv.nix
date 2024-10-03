{ config, lib, pkgs, ... }:

let
  sdcvConfig = pkgs.writeText "sdcvrc" ''
    # SDCV configuration
    use-dict "WordNet"
  '';

  localDictPath = "/home/jonash/Downloads/stardict/dic/stardict-dictd_www.dict.org_wn-2.4.2";
in
{
  environment.systemPackages = [ 
    (pkgs.sdcv.overrideAttrs (oldAttrs: rec {
      version = "0.5.5";
      src = pkgs.fetchFromGitHub {
        owner = "Dushistov";
        repo = "sdcv";
        rev = "v${version}";
        sha256 = "sha256-EyvljVXhOsdxIYOGTzD+T16nvW7/RNx3DuQ2OdhjXJ4=";
      };
    }))
  ];

  environment.etc."sdcvrc".source = sdcvConfig;

  system.activationScripts = {
    sdcvConfig = ''
      mkdir -p $HOME/.config
      ln -sf ${sdcvConfig} $HOME/.config/sdcvrc
    '';
    linkWordNetDict = ''
      mkdir -p /etc/stardict/dic
      ln -sf ${localDictPath} /etc/stardict/dic/WordNet
    '';
  };
}
