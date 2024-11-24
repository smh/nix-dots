{
  inputs,
  outputs,
  ...
}: {
  imports = [
    # <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
    "${modulesPath}/virtualisation/lxc-container.nix"
    inputs.home-manager.nixosModules.home-manager
    ./hardware.nix
    ../../modules/nixos
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users.smh = import ../../home/smh;
  };

  time.timeZone = "Asia/Dubai";
  services.openssh.enable = true;

  networking.hostName = "chasm-city";
}
