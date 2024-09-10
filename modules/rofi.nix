{ config, lib, pkgs, ... }:

let
  rofiConfig = pkgs.writeText "config.rasi" ''
    configuration {
      modi: "drun,run,window";
      icon-theme: "Oranchelo";
      show-icons: true;
      terminal: "kitty";
      drun-display-format: "{icon} {name}";
      location: 0;
      disable-history: false;
      hide-scrollbar: true;
      display-drun: "   Apps ";
      display-run: "   Run ";
      display-window: "   Window";
      display-Network: " 󰤨  Network";
      sidebar-mode: true;
    }

    @theme "catppuccin-mocha"

    window {
      width: 1000px;
      border: 3px;
      border-color: @border-col;
      border-radius: 12px;
      background-color: @bg-col;
    }

    mainbox {
      background-color: @bg-col;
    }

    inputbar {
      children: [prompt,entry];
      background-color: @bg-col;
      border-radius: 5px;
      padding: 2px;
    }

    prompt {
      background-color: @blue;
      padding: 6px;
      text-color: @bg-col;
      border-radius: 3px;
      margin: 20px 0px 0px 20px;
    }

    textbox-prompt-colon {
      expand: false;
      str: ":";
    }

    entry {
      padding: 6px;
      margin: 20px 0px 0px 10px;
      text-color: @fg-col;
      background-color: @bg-col;
    }

    listview {
      border: 0px 0px 0px;
      padding: 6px 0px 0px;
      margin: 10px 0px 0px 20px;
      columns: 2;
      lines: 5;
      background-color: @bg-col;
    }

    element {
      padding: 5px;
      background-color: @bg-col;
      text-color: @fg-col  ;
    }

    element-icon {
      size: 25px;
    }

    element selected {
      background-color:  @selected-col ;
      text-color: @fg-col2  ;
    }

    mode-switcher {
      spacing: 0;
    }

    button {
      padding: 10px;
      background-color: @bg-col-light;
      text-color: @grey;
      vertical-align: 0.5; 
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @blue;
    }

    message {
      background-color: @bg-col-light;
      margin: 2px;
      padding: 2px;
      border-radius: 5px;
    }

    textbox {
      padding: 6px;
      margin: 20px 0px 0px 20px;
      text-color: @blue;
      background-color: @bg-col-light;
    }
  '';

  rofiTheme = pkgs.writeText "catppuccin-mocha.rasi" ''
    * {
      bg-col:  #1e1e2e;
      bg-col-light: #1e1e2e;
      border-col: #89b4fa;
      selected-col: #45475a;
      blue: #89b4fa;
      fg-col: #cdd6f4;
      fg-col2: #f38ba8;
      grey: #6c7086;
      width: 600;
      font: "JetBrainsMono Nerd Font 14";
    }
  '';
in
{
  environment.systemPackages = [ pkgs.rofi ];

  environment.etc = {
    "xdg/rofi/config.rasi".source = rofiConfig;
    "xdg/rofi/catppuccin-mocha.rasi".source = rofiTheme;
  };

  environment.shellInit = ''
    if [ -z "$XDG_CONFIG_HOME" ]; then
      export XDG_CONFIG_HOME="$HOME/.config"
    fi
    mkdir -p "$XDG_CONFIG_HOME/rofi"
    ln -sf /etc/xdg/rofi/config.rasi "$XDG_CONFIG_HOME/rofi/config.rasi"
    ln -sf /etc/xdg/rofi/catppuccin-mocha.rasi "$XDG_CONFIG_HOME/rofi/catppuccin-mocha.rasi"
  '';
}
