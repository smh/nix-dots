{
  lib,
  pkgs,
  ...
}: {
  imports = [
    # ./modules/fonts
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
      # aider-chat
      direnv
      gh
      hub

      tree
      zoxide
      # nerdfonts.firacode
    ];
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
    git = {
      enable = true;
      userName = "Stein Martin Hustad";
      userEmail = "stein@hustad.com";
      aliases = {
        s = "status --short";
        st = "status";
        # ATTENTION: All aliases prefixed with ! run in /bin/sh make sure you use sh syntax, not bash/zsh or whatever
        #recentb = "!r() { refbranch=$1 count=$2; git for-each-ref --sort=-committerdate refs/heads --format='%(refname:short)|%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' --color=always --count=${count:-20} | while read line; do branch=$(echo \"$line\" | awk 'BEGIN { FS = \"|\" }; { print $1 }' | tr -d '*'); ahead=$(git rev-list --count \"${refbranch:-origin/main}..${branch}\"); behind=$(git rev-list --count \"${branch}..${refbranch:-origin/main}\"); colorline=$(echo \"$line\" | sed 's/^[^|]*|//'); echo \"$ahead|$behind|$colorline\" | awk -F'|' -vOFS='|' '{$5=substr($5,1,70)}1' ; done | ( echo \"ahead|behind||branch|lastcommit|message|author\\n\" && cat) | column -ts'|';}; r";
        # Difftastic aliases, so `git dlog` is `git log` with difftastic and so on.
        #dlog = "-c diff.external=difft log --ext-diff";
        #dshow = "-c diff.external=difft show --ext-diff";
        #ddiff = "-c diff.external=difft diff";
        # `git log` with patches shown with difftastic.
        #dl = "-c diff.external=difft log -p --ext-diff";
        # Show the most recent commit with difftastic.
        #ds = "-c diff.external=difft show --ext-diff";";
        # `git diff` with difftastic.
        #dft = "-c diff.external=difft diff";";
      };
      extraConfig = {
        merge = {
	  tool = "vimdiff";
	  conflictStyle = "diff3";
	};
	pull.rebase = true;
	push = {
	  default = "simple";
	  autoSetupRemote = "true";
	};
	github.user = "smh";
      };

      # includes = [
      #   path = "catpuccin.gitconfig";
      # ];
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    # wezterm = {
    #   enable = true;
    # };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
