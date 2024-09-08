{ config, pkgs, unstable, ... }:

{
  # Use Neovim from the unstable channel
  environment.systemPackages = [
    unstable.neovim
  ];

  # Configure Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    package = unstable.neovim;
  };

  # Ensure necessary tools are available system-wide
  # environment.systemPackages = with pkgs; [
  #   gcc
  #   python3
  # ];

  # Set up any necessary environment variables
  environment.variables = {
    EDITOR = "nvim";
  };
}
