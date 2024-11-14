{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # other packages
    (pkgs.callPackage (
      { stdenv, fetchFromGitHub, rustPlatform }:
      rustPlatform.buildRustPackage rec {
        pname = "neotop";
        version = "master";  # or a specific commit hash or tag

        src = fetchFromGitHub {
          owner = "cjbassi";
          repo = "neotop";
          rev = "master";  # or a specific commit hash or tag
          # sha256 = "hash-here";  # Replace with the actual hash from the commit you're using
        };

        cargoSha256 = "hash-here";  # Replace with the cargo lockfile hash

        meta = with pkgs.lib; {
          description = "Neotop - A modern system monitor";
          homepage = "https://github.com/cjbassi/neotop";
          # license = licenses.mit;
          # maintainers = with maintainers;[ ];  # Add your name if you maintain this package
        };
      }
    ) { })
  ];
}
