{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware.nix
    # ../../modules/nixos
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
