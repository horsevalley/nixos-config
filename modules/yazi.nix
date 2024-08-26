{ config, pkgs, ... }:

{
  description = "Yazi file manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        packages.default = pkgs.yazi;

          programs.yazi = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
          };

          # Yazi plugin installation
          system.activationScripts = {
            installYaziPlugins = ''
              YAZI_PLUGIN_DIR="$HOME/.config/yazi/plugins"
              if [ ! -d "$YAZI_PLUGIN_DIR" ]; then
                mkdir -p "$YAZI_PLUGIN_DIR"
                ${pkgs.git}/bin/git clone https://github.com/sxyazi/yazi.git /tmp/yazi
                cp -r /tmp/yazi/plugins/* "$YAZI_PLUGIN_DIR/"
                rm -rf /tmp/yazi
              fi
            '';
          };
        };
      }
    );
}
