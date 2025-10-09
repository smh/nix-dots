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
    git-lfs
    vim

    # CLI tools
    delta
    difftastic
    fd
    jq
    ripgrep
    tig
    tmux
    tree
    uv
    wget
    yq

    # Shell integration tools (needed at system level)
    starship
    zoxide

    # Development
    nixos-rebuild
    nodejs_24

    # Secrets Management
    sops
    ssh-to-age

    # Tools that need system-level access
    lazydocker
    wezterm
  ];

  # Necessary for using flakes on this system.
  nix.settings = {
    experimental-features = "nix-command flakes";
    extra-platforms = "x86_64-darwin aarch64-darwin x86_64-linux aarch64-linux";
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  # nixpkgs.hostPlatform = "aarch64-darwin";

  programs.fish.enable = true;
  environment.shells = [pkgs.fish];
  users.knownUsers = ["smh"];
  users.users.smh = {
    uid = 501;
    shell = pkgs.fish;
    home = "/Users/smh";
  };
}
