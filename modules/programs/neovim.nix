{ config, pkgs, unstable, ... }:

{
  environment.systemPackages = [
    (unstable.neovim.override {
      viAlias = true;
      vimAlias = true;
      withPython3 = true;
      withNodeJs = true;
      withRuby = true;
      withGo = true;
    })
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Force the system to use the unstable version
  nixpkgs.overlays = [
    (final: prev: {
      neovim = unstable.neovim;
    })
  ];
}
