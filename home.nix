{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "smh";
  home.homeDirectory = "/Users/smh";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    direnv
    zoxide
  ];

  programs = {
    direnv = {
      enable = true;
      # enableFishIntegration = true; # not really necessary - always enabled when direnv.enable set to true
      nix-direnv.enable = true;
    };
    fish = {
      enable = true;
      shellAliases = {
        vi = "nvim";
        dc = "docker compose";
      };
      plugins = [
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
