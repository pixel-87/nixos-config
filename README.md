# NixOS Configuration

This repository contains my personal declarative system configuration using NixOS, Flakes, and Home Manager.

## Hosts

- `laptop`: Personal laptop setup.
- `lithium`: Desktop/server setup.

## Structure

- `flake.nix`: Entrypoint for system configurations.
- `hosts/`: Machine-specific configurations.
  - `common/`: Shared configuration applied across all hosts.
  - `<hostname>/`: Host-specific hardware and software configuration.
- `modules/`: Custom Nix modules.
  - `nixos/`: System-level modules.
  - `home/`: User-level Home Manager modules.
- `pkgs/`: Custom packages.
- `k8s/`: Kubernetes manifests.

## Usage

Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

Apply a configuration (e.g., for `laptop`):
```bash
sudo nixos-rebuild switch --flake .#laptop
```