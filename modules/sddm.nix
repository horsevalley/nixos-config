{ config, pkgs, ... }:

{
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
    settings = {
      Theme = {
        ThemeDir = "/run/current-system/sw/share/sddm/themes";
        Current = "catppuccin-mocha";
      };
      Wayland = {
        EnableHiDPI = true;
      };
    };
  };

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
    })
  ];

  system.activationScripts = {
    sddm-theme-config = ''
      mkdir -p /etc/sddm/catppuccin-mocha
      ln -sf ${./sddm/catppuccin-mocha.conf} /etc/sddm/catppuccin-mocha/theme.conf
    '';
  };
}
