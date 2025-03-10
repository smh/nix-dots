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
    git-lfs
    htop
    jq
    lazydocker
    lazygit
    neovim
    nixos-rebuild
    nodejs_23
    ripgrep
    starship
    tig
    tmux
    tree
    uv
    vim
    wezterm
    wget
    yq
    zoxide
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

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
