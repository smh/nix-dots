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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    nixos-generators,
    modulesPath,
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
          "${modulesPath}/virtualisation/lxc-container.nix"
        ];
      };
    };

    nixosConfigurations = {
        chasm-city = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit self inputs;};
          modules = [
            ./machines/chasm-city
          ];
        };
      };

    # Add Proxmox LXC image generation
    packages.x86_64-linux.chasm-city = nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      format = "proxmox-lxc";
      specialArgs = {inherit self inputs;};
      modules = [
        ./machines/chasm-city
      ];
    };
  };
}
