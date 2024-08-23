{ lib, stdenv, fetchFromGitHub }:

{
  stdenv.mkDerivation rec {
  pname = "catppuccin-sddm";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "7fc67d1027cdb7f4d833c5d23a8c34a0029b0661"; # This is the latest commit as of now
    sha256 = "sha256-SjYwyUvvx/ageqVH5MmYmHNRKNvvnF3DYMJ/f2/L+Go="; # Updated hash
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r src/catppuccin-mocha $out/share/sddm/themes/catppuccin
  '';

  meta = with lib; {
    description = "Catppuccin theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
