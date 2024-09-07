{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jonas Hestdahl";
    userEmail = "hestdahl@gmail.com";
    # Add any other git configurations you had in your previous setup
  };
}
