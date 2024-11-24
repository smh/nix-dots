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
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = "24.11";

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
