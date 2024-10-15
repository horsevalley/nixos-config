{ config, pkgs, lib, ... }:

let
  exodus = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "exodus";
    version = "24.3.15"; # Update this when a new version is released

    src = pkgs.fetchurl {
      name = "exodus-linux-x64-${finalAttrs.version}.zip";
      url = "https://downloads.exodus.com/releases/exodus-linux-x64-${finalAttrs.version}.zip";
      sha256 = "sha256-aYYZv0z9ZZYm31QoJhZhRFW+NQ7KsxnNnF4G9n4KxiM="; # Update this when changing the version
    };

    nativeBuildInputs = [ pkgs.unzip ];

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
      maintainers = with maintainers; [ mmahut rople380 ];
      platforms = [ "x86_64-linux" ];
    };
  });
in
{
  environment.systemPackages = [ exodus ];

  nixpkgs.config.allowUnfree = true;
}
