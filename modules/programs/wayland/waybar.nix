{ config, lib, pkgs, ... }:

let
  mediaplayer = pkgs.writeShellScriptBin "mediaplayer" (builtins.readFile ./mediaplayer.sh);
in
{
  environment.systemPackages = with pkgs; [
    waybar
    playerctl
    mpc-cli
    mediaplayer
    pulsemixer
  ];

  environment.etc = {
    "xdg/waybar/config".source = ./waybar-config.json;
    "xdg/waybar/style.css".text = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(43, 48, 59, 0.5);
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #ffffff;
      }

      #workspaces button.active {
        background: lightcoral;
      }

      #clock, #battery, #cpu, #memory, #temperature, #backlight, #network, #pulseaudio, #custom-media, #tray {
        padding: 0 10px;
        margin: 0 5px;
      }

      #clock {
        background-color: #64727D;
      }

      #battery {
        background-color: #ffffff;
        color: black;
      }

      #battery.charging {
        color: white;
        background-color: #26A65B;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: black;
        }
      }

      #battery.warning:not(.charging) {
        background: #f53c3c;
        color: white;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
    '';
  };

  environment.sessionVariables = {
    PATH = [
      "${mediaplayer}/bin"
    ] ++ (lib.optional (config.environment.sessionVariables ? PATH) config.environment.sessionVariables.PATH);
  };
}
