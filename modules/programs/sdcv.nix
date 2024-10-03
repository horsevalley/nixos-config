{ config, lib, pkgs, ... }:

let
  sdcvConfig = pkgs.writeText "sdcvrc" ''
    # SDCV configuration
    # You can add any sdcv-specific configurations here
    # For example:
     use-dict "WordNet"
    # use-dict "Another Dictionary"
  '';
in
{
  environment.systemPackages = [ 
    (pkgs.sdcv.overrideAttrs (oldAttrs: rec {
      version = "0.5.5";  # You can update this to a newer version if available
      src = pkgs.fetchFromGitHub {
        owner = "Dushistov";
        repo = "sdcv";
        rev = "v${version}";
        sha256 = "1cg9g30i59wd8vn2xrhxgv0wdgvpgxycyifqmchjpcc3qadcv5h2";  # You may need to update this
      };
    }))
  ];

  environment.etc."sdcvrc".source = sdcvConfig;

  system.activationScripts = {
    sdcvConfig = ''
      mkdir -p $HOME/.config
      ln -sf ${sdcvConfig} $HOME/.config/sdcvrc
    '';
  };
}
