{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # ghostty.url = "github:ghostty-org/ghostty";

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
      url = "github:catppuccin/tmux/v2.1.3";
      flake = false;
    };
    tmux-battery = {
      url = "github:tmux-plugins/tmux-battery/91b05110cc35863e3f6c3992c9f92916732b26ac";
      flake = false;
    };
    tmux-nerd-font-window-name = {
      url = "github:joshmedeski/tmux-nerd-font-window-name/ab9c2cd2bfbbcf6f85ffff359d69b6a8712daf05";
      flake = false;
    };
    vim-tmux-navigator = {
      url = "github:christoomey/vim-tmux-navigator/c45243dc1f32ac6bcf6068e5300f3b2b237e576a";
      flake = false;
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    # ghostty,
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
        specialArgs = {inherit self inputs;};
        modules = [
          ./machines/nostalgia
          inputs.mac-app-util.darwinModules.default
        ];
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

      resurgam = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit self inputs;};
        modules = [
          ./machines/resurgam
        ];
      };
    };

    # Add VmWare and lxc image generation
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

      x86_64-linux.resurgam-lxc = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "proxmox-lxc";
        specialArgs = {inherit self inputs;};
        modules = [
          ./machines/resurgam
        ];
      };
    };
  };
}
