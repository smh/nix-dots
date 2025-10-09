{
  inputs,
  outputs,
  modulesPath,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
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

  # sops-nix configuration
  sops = {
    defaultSopsFile = ../../secrets/common.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      certbot-ssh-key = {
        key = "certbot/ssh_key";
      };
      sonarr-api-key = {
        sopsFile = ../../secrets/homelab.yaml;
        key = "recyclarr/sonarr/api_key";
        owner = "recyclarr";
        group = "recyclarr";
      };
      radarr-api-key = {
        sopsFile = ../../secrets/homelab.yaml;
        key = "recyclarr/radarr/api_key";
        owner = "recyclarr";
        group = "recyclarr";
      };
    };
  };
}
