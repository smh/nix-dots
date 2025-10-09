{
  inputs,
  outputs,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
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

  networking.hostName = "resurgam";

  # Docker for running databases and applications
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # Development packages for Java/React development
  environment.systemPackages = with pkgs; [
    docker-compose
    git
    # Java development
    jdk21
    maven
    gradle
    # Node.js for React development
    nodejs_22
    # Useful tools
    vim
    tmux
    htop
    curl
    wget
    # mainly for the correct terminal xterm-ghostty
    ghostty
    # inputs.ghostty.packages.x86_64-linux.default
  ];

  #environment.etc."terminfo/x/xterm-ghostty".source = "${pkgs.ghostty}/share/terminfo/x/xterm-ghostty";


  users.users.smh.extraGroups = ["docker"];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # sops-nix configuration
  sops = {
    defaultSopsFile = ../../secrets/common.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
}
