{ config, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./X11.nix
    ./gnome.nix
    ./programs/wayland/hyprland.nix
    ./neovim.nix
    ./fonts.nix
    ./hardware/opengl.nix
    ./keyboard.nix
    ./localization.nix
    ./networking.nix
    ./packages.nix
    ./security.nix
    ./services.nix
    ./shell.nix
    ./system.nix
    ./users.nix
    ./variables.nix
    ./pcmanfm.nix
    ./sddm.nix
    ./yazi.nix
    ./git.nix
    ./librewolf.nix
    ./zsh.nix
    ./zathura.nix
    ./mpv.nix
    ./dunst.nix
    ./kitty.nix
    ./newsboat.nix
    ./pass.nix
    ./gpg.nix
    ./rofi.nix
    ./eww.nix
  ];
}
