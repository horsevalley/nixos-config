# jonash NixOS Multi-Machine Configuration

This repository contains a NixOS configuration for managing multiple machines using a modular approach.

## Structure

- `flake.nix`: The entry point for the Nix flake, defining the overall structure and inputs.
- `hosts/`: Contains machine-specific configurations.
  - `common/`: Shared configuration for all machines.
  - `laptop/`: Configuration specific to the laptop.
  - `workstation/`: Configuration specific to the workstation.
- `modules/`: Contains modular configurations for various system components.

## Usage

To build and activate the configuration for a specific machine:

1. For the workstation:
   ```
   sudo nixos-rebuild switch --flake .#workstation
   ```

2. For the laptop:
   ```
   sudo nixos-rebuild switch --flake .#laptop
   ```

## Customization

To add a new machine or modify existing configurations:

1. Create a new directory under `hosts/` for the new machine.
2. Add machine-specific configuration in `hosts/<machine-name>/default.nix`.
3. Add the machine to the `nixosConfigurations` in `flake.nix`.
4. Modify or add modules in the `modules/` directory as needed.

## Maintenance

Remember to regularly update your flake inputs:

```
nix flake update
```

## Contributing

Feel free to submit issues or pull requests if you have suggestions for improvements or encounter any problems.
