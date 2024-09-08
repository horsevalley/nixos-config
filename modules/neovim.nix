{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    (unstable.neovim.override {
      viAlias = true;
      vimAlias = true;
      withPython3 = true;
      withNodeJs = true;
      withRuby = true;
    })
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
