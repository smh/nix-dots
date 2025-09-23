{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    # ./modules/fonts
    ./programs/git
    ./programs/tmux # { inherit inputs; }
    ./programs/wezterm
  ];

  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";

    packages = with pkgs; [
      # User-specific tools not in system packages
      glow
      hub
      # ghostty - currently (1.1.2) marked broken on darwin
      # nerdfonts.firacode

      # Development tools (keep in user profile)
      yarn-berry
      python3
      ruby
    ];

    file.".npmrc".text = ''
      prefix=${config.home.homeDirectory}/.cache/npm/global
    '';

    sessionVariables = {
      PATH = "$HOME/.cache/npm/global/bin:$PATH";
    };
  };

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
        tm = "task-master";
      };
      plugins = [
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    # Additional program configurations
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    htop = {
      enable = true;
      settings = {
        show_program_path = false;
      };
    };

    lazygit = {
      enable = true;
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
