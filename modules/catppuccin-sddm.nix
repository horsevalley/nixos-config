{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "catppuccin-sddm";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "7fc67d1027cdb7f4d833c5d23a8c34a0029b0661"; # Check for the latest commit hash
    sha256 = "fOVgWNE8NWbWHlu+EAmxSz+QJ6y+IODc/u3UF+JWQqA=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r src/catppuccin-mocha $out/share/sddm/themes/catppuccin
  '';
}
