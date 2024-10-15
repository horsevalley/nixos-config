{ config, pkgs, lib, ... }:

let
  exodusVersion = "24.3.15"; # Update this when a new version is released

  exodusUrl = "https://downloads.exodus.com/releases/exodus-linux-x64-${exodusVersion}.zip";

  exodus = pkgs.appimageTools.wrapType2 {
    name = "exodus";
    src = pkgs.fetchzip {
      url = exodusUrl;
      stripRoot = false;
      # Use a hash placeholder. Nix will complain and provide the correct hash on first run.
      hash = lib.fakeHash;
    };

    extraPkgs = pkgs: with pkgs; [
      glib
      nss
      nspr
      gtk3
      pango
      atk
      cairo
      gdk-pixbuf
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrender
      xorg.libxshmfence
      xorg.libXtst
      xorg.libXrandr
      xorg.libXScrnSaver
      alsa-lib
      dbus
      at-spi2-atk
      at-spi2-core
      cups.lib
      libpulseaudio
      systemd
      libxkbcommon
      mesa
    ];
  };
in
{
  environment.systemPackages = [ exodus ];

  nixpkgs.config.allowUnfree = true;
}
