{
  pkgs,
  self,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Core system utilities
    broot
    coreutils
    curl
    git
    git-extras
    vim

    # CLI tools
    delta
    difftastic
    fd
    jq
    ripgrep
    tig
    tmux
    wget
    yq

    # Shell integration tools (needed at system level)
    starship
    zoxide

    # Tools that need system-level access
    lazydocker
    wezterm
  ];

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "smh" "@wheel" ];  # Add any other trusted users
    trusted-public-keys = [ "local-builder:HT9p32L2PhqcLjmuhpcr/7y+AtUunP4vGQhJT7Zo+0Q=" ];
    accept-flake-config = true;
    allowed-users = [ "@wheel" ];
  };

  # Enable mDNS for `hostname.local` addresses
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = "24.11";

  # The platform the configuration will be used on.
  # nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {
    fish.enable = true;
    command-not-found.enable = false; # incompatible with/replaced by nix-index
    nix-index.enable = true;
  };

  environment.shells = [pkgs.fish];
  # users.knownUsers = ["smh"];
  users.users.smh = {
    # uid = 501;
    shell = pkgs.fish;
    home = "/home/smh";
    password = "rema1000";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDdhFAELwOVPH8ywfeOqgty+vMtepL+vftzh8xIOF3Y smh@Jennifer.svingen"
    ];
  };

  # Enable password-based SSH login for root
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = null; # everyone
      PasswordAuthentication = true; # this is just a sandbox
      PermitRootLogin = "no";
    };
  };
}
