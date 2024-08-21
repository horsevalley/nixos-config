let
  unstablePkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "0awagdjzv2fsy5v7a0wxz1hd642gsglib2gk4lnqm0iybly7kf0s";  # You need find or generate this hash yourself
  }) {
    system = pkgs.system;
  };
in {
  environment.systemPackages = with unstablePkgs; [
    neovim
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
}
