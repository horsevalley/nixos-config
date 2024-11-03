{ config, pkgs, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    file
    imagemagick
    kitty
  ];

  nixpkgs.overlays = [
    (final: prev: {
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
    })
  ];
}
