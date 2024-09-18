{ config, pkgs, ... }:

let
  theme = pkgs.kdePackages.kde-gtk-config;  # Or choose another GTK theme package
  icons = pkgs.gnome.adwaita-icon-theme;    # Or choose another icon theme package
in {
  environment.systemPackages = with pkgs; [
    pcmanfm
    theme
    icons
  ];

  # GTK settings for pcmanfm
  environment.variables = {
    GTK_THEME = "Adwaita:dark";  # Or set to your preferred dark theme
    GTK_ICON_THEME = "Adwaita";   # Or set to your preferred icon theme
  };

  # Example of applying transparency (This may depend on the window manager/compositor configuration)
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Adwaita
    gtk-enable-animations=false
  '';
  
  # Configure pcmanfm settings declaratively
  environment.etc."xdg/pcmanfm/default/pcmanfm.conf".text = ''
    [Desktop]
    wallpaper_mode=stretch
    wallpaper=~/repos/github/wallpapers/JaKooLit/Dynamic-Wallpapers/Dark/Mountain_dark.png

    [GTK]
    theme=Adwaita-dark
    icons=Adwaita
    enable_transparency=true
    transparency = 0.8

    [UI]
    always_show_tabs=true
  '';

}

