# Nix-dots Repository Guide

## Commands
- Format code: `nix fmt`
- Build darwin system: `darwin-rebuild switch --flake .#nostalgia`
- Build NixOS system: `nixos-rebuild switch --flake .#chasm-city`
- Build VM image: `nix build .#chasm-city`
- Build LXC container: `nix build .#chasm-city-lxc`
- Format with Alejandra: `nix fmt`

## Code Style
- Nix formatting: 2-space indentation, formatted with Alejandra
- File structure: modules organized by platform (darwin, nixos, homelab)
- Naming: kebab-case for files, camelCase for directories
- Imports: prefer explicit imports, avoid using `...` when possible
- Use modular structure with default.nix files for entry points
- Prefer declarative configurations over imperative scripts
- Follow the home-manager module structure for user configurations

## Repository Structure
- `/machines`: System configurations (NixOS, nix-darwin)
- `/home`: User-specific configurations (home-manager)
- `/modules`: Shared configuration modules
- `/overlays`: Package customizations and overrides