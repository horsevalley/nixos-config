{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonash = {
    isNormalUser = true;
    description = "Jonas Hestdahl";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "user" "audio" "pipewire" "pulse" "pulse-access" "video" "input" "lib" "mpd" ];
    packages = with pkgs; [];
  };
}
