{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../../modules/darwin
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users.smh = import ../../home/smh;
  };

  networking.hostName = "nostalgia";
}
