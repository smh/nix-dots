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

  networking = {
    hostName = "nostalgia";
    computerName = "nostalgia";
    localHostName = "nostalgia";
  };

  # Optionally, use home-manager.extraSpecialArgs to pass
  # arguments to home.nix
}
