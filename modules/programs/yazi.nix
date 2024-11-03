{ config, pkgs, unstable, ... }:
let
  final = pkgs.extend (final: prev: {
    _7zz = prev._7zz.override {
      enableAsm = false;
      useSystemAsm = false;
      useMasm = false;
    };
    yazi = (unstable.yazi.override {
      inherit (_7zz);
    }).overrideAttrs (old: {
      buildInputs = (old.buildInputs or []) ++ [
        final._7zz
      ];
    });
  });
in
{
  environment.systemPackages = with pkgs; [
    final.yazi
    file
    imagemagick
    kitty
  ];

  nixpkgs.overlays = [
    (final: prev: {
      inherit (final) _7zz yazi;
    })
  ];
}
