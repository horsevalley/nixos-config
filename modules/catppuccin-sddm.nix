{ config, lib, pkgs, ... }:

let
  catppuccin-sddm = pkgs.stdenv.mkDerivation {
    pname = "catppuccin-sddm";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "7fc67d1027cdb7f4d833c5d23a8c34a0029b0661";
      sha256 = "sha256-SjYwyUvvx/ageqVH5MmYmHNRKNvvnF3DYMJ/f2/L+Go=";
    };

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r src/catppuccin-mocha $out/share/sddm/themes/catppuccin
    '';
  };
in
{
  environment.systemPackages = [ catppuccin-sddm ];

  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "catppuccin";
  };
}
