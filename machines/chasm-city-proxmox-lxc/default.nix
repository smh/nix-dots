{
  inputs,
  outputs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
    inputs.home-manager.nixosModules.home-manager
    ./hardware.nix
    ../../modules/nixos
    ../../modules/homelab
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users.smh = import ../../home/smh;
  };

  time.timeZone = "Asia/Dubai";
  services.openssh.enable = true;

  networking.hostName = "chasm-city-proxmox-lxc";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
}
