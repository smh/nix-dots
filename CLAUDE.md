# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

## Architecture
This is a multi-platform Nix configuration using flakes:
- **Darwin support**: macOS systems via nix-darwin (machine: nostalgia)
- **NixOS support**: Linux systems with VM/container variants (machines: chasm-city, chasm-city-proxmox-lxc)
- **Home-manager integration**: Platform-agnostic user configurations
- **Homelab module**: Docker Compose-based media server stack (*arr services) with NFS mounts
- **Flake inputs**: All dependencies pinned through flake.lock
- **nixos-generators**: Used for building VM and container images