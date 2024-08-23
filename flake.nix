{
  description = "My NixOS configuration with modular flakes";

  # inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      horsepowr-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/audio.nix
          ./modules/X11.nix
          ./modules/gnome.nix
          ./modules/programs/wayland/hyprland.nix
          ./modules/programs/wayland/waybar.nix
          ./modules/neovim.nix
          ./modules/fonts.nix
          ./modules/hardware/nvidia.nix
          ./modules/hardware/opengl.nix
          ./modules/hardware.nix
          ./modules/keyboard.nix
          ./modules/localization.nix
          ./modules/networking.nix
          ./modules/packages.nix
          ./modules/security.nix
          ./modules/services.nix
          ./modules/shell.nix
          ./modules/system.nix
          ./modules/users.nix
          ./modules/variables.nix
          ./modules/pcmanfm.nix
          # ./modules/catppuccin-sddm.nix
        ];
      };
    };
  };
}

