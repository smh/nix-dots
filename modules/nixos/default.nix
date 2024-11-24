{
  pkgs,
  self,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    bat
    broot
    coreutils
    curl
    delta
    difftastic
    fd
    fish
    fzf
    git
    git-extras
    htop
    jq
    lazydocker
    lazygit
    neovim
    ripgrep
    starship
    tig
    tmux
    vim
    wezterm
    wget
    yq
  ];

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "smh" ];  # Add any other trusted users
    trusted-public-keys = [ "local-builder:wBAYW4YNZiiqRtjw+iXYEglSDHlwDc7RpCcH1AQpXHA=" ];
    accept-flake-config = true;
    allowed-users = [ "@wheel" ];
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = "24.11";

  # The platform the configuration will be used on.
  # nixpkgs.hostPlatform = "aarch64-darwin";

  programs.fish.enable = true;
  environment.shells = [pkgs.fish];
  # users.knownUsers = ["smh"];
  users.users.smh = {
    # uid = 501;
    shell = pkgs.fish;
    home = "/home/smh";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDdhFAELwOVPH8ywfeOqgty+vMtepL+vftzh8xIOF3Y smh@Jennifer.svingen"
    ];
  };

  # Enable password-based SSH login for root
  services.openssh = {
    enable = true;
    #settings = {
    #  AllowUsers = null; # everyone
    #  PasswordAuthentication = true; # this is just a sandbox
    #  PermitRootLogin = "yes";
    #};
  };
}
