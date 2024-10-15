{ config, pkgs, lib, ... }:

let
  exodusVersion = "24.3.15"; # Update this when a new version is released

  exodus = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "exodus";
    version = exodusVersion;

    src = ~/Downloads/exodus-linux-x64-24.41.3.zip # Replace with actual path

    nativeBuildInputs = [ pkgs.unzip ];

    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      unzip $src -d $out
      ln -s $out/Exodus $out/bin/Exodus
      ln -s $out/bin/Exodus $out/bin/exodus
      mv $out/exodus.desktop $out/share/applications/
      substituteInPlace $out/share/applications/exodus.desktop \
        --replace 'Exec=bash -c "cd \`dirname %k\` && ./Exodus %u"' "Exec=Exodus %u"
    '';

    dontPatchELF = true;
    dontBuild = true;

    preFixup = let
      libPath = lib.makeLibraryPath [
        pkgs.glib
        pkgs.nss
        pkgs.nspr
        pkgs.gtk3
        pkgs.pango
        pkgs.atk
        pkgs.cairo
        pkgs.gdk-pixbuf
        pkgs.xorg.libX11
        pkgs.xorg.libxcb
        pkgs.xorg.libXcomposite
        pkgs.xorg.libXcursor
        pkgs.xorg.libXdamage
        pkgs.xorg.libXext
        pkgs.xorg.libXfixes
        pkgs.xorg.libXi
        pkgs.xorg.libXrender
        pkgs.xorg.libxshmfence
        pkgs.xorg.libXtst
        pkgs.xorg.libXrandr
        pkgs.xorg.libXScrnSaver
        pkgs.alsa-lib
        pkgs.dbus
        pkgs.at-spi2-atk
        pkgs.at-spi2-core
        pkgs.cups.lib
        pkgs.libpulseaudio
        pkgs.systemd
        pkgs.libxkbcommon
        pkgs.mesa
      ];
    in ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/Exodus
    '';

    meta = with lib; {
      description = "Top-rated cryptocurrency wallet with Trezor integration and built-in Exchange";
      homepage = "https://www.exodus.com/";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  });
in
{
  environment.systemPackages = [ exodus ];

  nixpkgs.config.allowUnfree = true;
}
