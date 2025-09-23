{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../../modules/darwin
    ./homebrew.nix
    # ./plex-media-server.nix
  ];

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;

    overlays = [
      (import ../../overlays)
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "nix-backup";
    users.smh = import ../../home/smh;
    
    # Enable mac-app-util for all users
    sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];
  };

  networking.hostName = "nostalgia";

  system.primaryUser = "smh";
}
