{ config, lib, pkgs, ... }:

let
  sdcvConfig = pkgs.writeText "sdcvrc" ''
    # SDCV configuration
    dictionary-path /home/jonash/Downloads/stardict/dic
  '';

  sdcvWrapper = pkgs.writeScriptBin "sdcv" ''
    #!${pkgs.bash}/bin/bash
    echo "SDCV_DICPATH: $SDCV_DICPATH"
    echo "Content of dictionary folder:"
    ls -l /home/jonash/Downloads/stardict/dic
    echo "Running sdcv..."
    ${pkgs.sdcv}/bin/sdcv --data-dir=/home/jonash/Downloads/stardict/dic -v "$@"
  '';
in
{
  environment.systemPackages = with pkgs; [ 
    (sdcv.overrideAttrs (oldAttrs: rec {
      version = "0.5.5";
      src = fetchFromGitHub {
        owner = "Dushistov";
        repo = "sdcv";
        rev = "v${version}";
        sha256 = "sha256-EyvljVXhOsdxIYOGTzD+T16nvW7/RNx3DuQ2OdhjXJ4=";
      };
    }))
    sdcvWrapper
    goldendict
  ];

  environment.etc."sdcvrc".source = sdcvConfig;

  system.activationScripts = {
    sdcvConfig = ''
      mkdir -p $HOME/.config
      ln -sf /etc/sdcvrc $HOME/.config/sdcvrc
    '';
  };

  environment.variables.SDCV_DICPATH = "/home/jonash/Downloads/stardict/dic";
}
