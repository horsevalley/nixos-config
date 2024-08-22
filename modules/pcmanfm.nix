{ config, pkgs, ... }:

{

  let
  theme = pkgs.gtk3.kde-gtk-config;  # Or choose another GTK theme package
  icons = pkgs.adwaita-icon-theme;    # Or choose another icon theme package
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
  services.gtk3.enable = true;
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Adwaita
    gtk-enable-animations=true
  '';

  # Hyprland-specific settings for transparency (this assumes you have Hyprland configured for transparency)
  programs.hyprland.settings = {
    decoration {
    blur = true;  # if you want blurred transparency
  }
    # Set other Hyprland transparency settings as needed
    };

  # Configure pcmanfm to use the dark theme and icons
  programs.pcmanfm = {
    enable = true;
    configFile = ./pcmanfm.conf;
  };

  };

}
