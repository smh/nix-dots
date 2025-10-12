# Nix-dots

Multi-platform Nix configuration using flakes for macOS (nix-darwin) and NixOS systems.

## Quick Start

- **Format code**: `nix fmt`
- **Build darwin system**: `darwin-rebuild switch --flake .#nostalgia`
- **Build NixOS system**: `nixos-rebuild switch --flake .#chasm-city`
- **Build VM image**: `nix build .#chasm-city`
- **Build LXC container**: `nix build .#chasm-city-lxc`

## Infrastructure

All servers are named after locations and ships from the Revelation Space series by Alastair Reynolds.

### Proxmox Servers

#### ghostline
Main Proxmox server hosting:
- **chasm-city** - LXC container running arr-suite and Plex in Docker containers

#### skyline
Proxmox server for network infrastructure:
- **shadowplay** - VM running pfSense firewall for home/homelab
- **grindstone** - LXC container running Pi-hole as DNS server (uses shadowplay as upstream DNS)

### Workstations

- **nostalgia** - MacBook Pro M1

## Repository Structure

- `/machines`: System configurations (NixOS, nix-darwin)
- `/home`: User-specific configurations (home-manager)
- `/modules`: Shared configuration modules
- `/overlays`: Package customizations and overrides

## Architecture

- **Darwin support**: macOS systems via nix-darwin
- **NixOS support**: Linux systems with VM/container variants
- **Home-manager integration**: Platform-agnostic user configurations
- **Homelab module**: Docker Compose-based media server stack with NFS mounts
- **nixos-generators**: Used for building VM and container images

## Code Style

- Nix formatting: 2-space indentation, formatted with Alejandra
- File structure: modules organized by platform (darwin, nixos, homelab)
- Naming: kebab-case for files, camelCase for directories
- Imports: prefer explicit imports
- Use modular structure with default.nix files for entry points
