{ config, pkgs, unstable, lib, ... }:

let
  exodus = unstable.stdenv.mkDerivation (finalAttrs: {
    pname = "exodus";
    version = unstable.exodus.version;

    src = unstable.fetchurl {
      name = "exodus-linux-x64-${finalAttrs.version}.zip";
      url = "https://downloads.exodus.com/releases/exodus-linux-x64-${finalAttrs.version}.zip";
      curlOptsList = [ "--user-agent" "Mozilla/5.0" ];
      hash = unstable.exodus.src.outputHash;
    };

    nativeBuildInputs = [ unstable.unzip ];

    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      cp -r . $out
      ln -s $out/Exodus $out/bin/Exodus
      ln -s $out/bin/Exodus $out/bin/exodus
      ln -s $out/exodus.desktop $out/share/applications
      substituteInPlace $out/share/applications/exodus.desktop \
            --replace 'Exec=bash -c "cd \`dirname %k\` && ./Exodus %u"' "Exec=Exodus %u"
    '';

    dontPatchELF = true;
    dontBuild = true;

    preFixup = let
      libPath = lib.makeLibraryPath [
        unstable.glib
        unstable.nss
        unstable.nspr
        unstable.gtk3
        unstable.pango
        unstable.atk
        unstable.cairo
        unstable.gdk-pixbuf
        unstable.xorg.libX11
        unstable.xorg.libxcb
        unstable.xorg.libXcomposite
        unstable.xorg.libXcursor
        unstable.xorg.libXdamage
        unstable.xorg.libXext
        unstable.xorg.libXfixes
        unstable.xorg.libXi
        unstable.xorg.libXrender
        unstable.xorg.libxshmfence
        unstable.xorg.libXtst
        unstable.xorg.libXrandr
        unstable.xorg.libXScrnSaver
        unstable.alsa-lib
        unstable.dbus
        unstable.at-spi2-atk
        unstable.at-spi2-core
        unstable.cups.lib
        unstable.libpulseaudio
        unstable.systemd
        unstable.libxkbcommon
        unstable.mesa
      ];
    in ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/Exodus
    '';

    meta = unstable.exodus.meta;
  });
in
{
  environment.systemPackages = [ exodus ];

  # Force the system to use our custom unstable version
  nixpkgs.overlays = [
    (final: prev: {
      exodus = exodus;
    })
  ];

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;
}
