{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    tmux-catppuccin = {
      url = "github:catppuccin/tmux/v2.1.1";
      flake = false;
    };
    tmux-battery = {
      url = "github:tmux-plugins/tmux-battery/48fae59ba4503cf345d25e4e66d79685aa3ceb75";
      flake = false;
    };
    tmux-nerd-font-window-name = {
      url = "github:joshmedeski/tmux-nerd-font-window-name/e0f3946227e5e7b5a94a24f973c842fa5a385e7f";
      flake = false;
    };
    vim-tmux-navigator = {
      url = "github:christoomey/vim-tmux-navigator/2d8bc8176af90935fb918526b0fde73d6ceba0df";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    nixos-generators,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    darwinConfigurations = {
      nostalgia = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self inputs; };
        modules = [ ./machines/nostalgia ];
      };
    };

    nixosConfigurations = {
      chasm-city = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit self inputs;};
        modules = [
          ./machines/chasm-city
          # "${nixpkgs}/nixos/modules/virtualisation/vmware-guest.nix"
          # {
          #   # Add VMware specific configuration
          #   virtualisation.vmware.guest.enable = true;
          #   # Set disk size
          #   disk.size = "153600M";
          # }
          # "${nixpkgs}/nixos/modules/virtualisation/lxc-container.nix"
        ];
      };

      chasm-city-proxmox-lxc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit self inputs;};
        modules = [
          ./machines/chasm-city-proxmox-lxc
        ];
      };
    };

    # Add VmWare image generation
    packages = {
      x86_64-linux.chasm-city = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "proxmox";
        specialArgs = {inherit self inputs;};
        modules = [
          ./machines/chasm-city
        ];
      };


      # Add Proxmox LXC image generation
      x86_64-linux.chasm-city-lxc = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "proxmox-lxc";
        specialArgs = {inherit self inputs;};
        modules = [
          ./machines/chasm-city-proxmox-lxc
        ];
      };
    };
  };
}
