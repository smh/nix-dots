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
    ./programs/ghostty
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
      ghostty-bin
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
      PATH = "$HOME/bin:$HOME/.docker/bin:$HOME/.cache/npm/global/bin:$PATH";
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

    # AeroSpace window manager
    aerospace = {
      enable = true;
      launchd.enable = true;
      userSettings = {
        # start-at-login is automatically set to false when launchd.enable = true

        # Appearance and layout
        accordion-padding = 30;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        # Normalizations
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        # Key mapping
        key-mapping.preset = "qwerty";

        # Mouse follows focus when focused monitor changes
        on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];

        # Gaps between windows
        gaps = {
          inner.horizontal = 5;
          inner.vertical = 5;
          outer.left = 5;
          outer.bottom = 5;
          outer.top = 5;
          outer.right = 5;
        };

        # Workspace to monitor assignments
        workspace-to-monitor-force-assignment = {
          "1" = "main";
          "2" = "main";
          "3" = "main";
          "4" = "main";
          "5" = "main";
          "6" = "built-in.*";
          "7" = "built-in.*";
          "8" = "built-in.*";
          "9" = "built-in.*";
          "B" = "main";
          "C" = "main";
          "D" = "built-in.*";
          "M" = "built-in.*";
          "S" = "built-in.*";
          "T" = "main";
        };

        # Key bindings
        mode.main.binding = {
          # Disable annoying shortcuts
          "cmd-h" = [];
          "cmd-alt-h" = [];

          # Layout commands
          "alt-slash" = "layout tiles horizontal vertical";
          "alt-comma" = "layout accordion horizontal vertical";
          "alt-shift-space" = "layout floating tiling";

          # Focus commands
          "alt-h" = "focus left";
          "alt-j" = "focus down";
          "alt-k" = "focus up";
          "alt-l" = "focus right";

          # Move commands
          "alt-shift-h" = "move left";
          "alt-shift-j" = "move down";
          "alt-shift-k" = "move up";
          "alt-shift-l" = "move right";

          # Resize commands
          "alt-shift-minus" = "resize smart -50";
          "alt-shift-equal" = "resize smart +50";

          # Workspace navigation
          "alt-1" = "workspace 1";
          "alt-2" = "workspace 2";
          "alt-3" = "workspace 3";
          "alt-4" = "workspace 4";
          "alt-5" = "workspace 5";
          "alt-6" = "workspace 6";
          "alt-7" = "workspace 7";
          "alt-8" = "workspace 8";
          "alt-9" = "workspace 9";
          "alt-b" = "workspace B";
          "alt-c" = "workspace C";
          "alt-d" = "workspace D";
          "alt-m" = "workspace M";
          "alt-s" = "workspace S";
          "alt-t" = "workspace T";

          # Move to workspace
          "alt-shift-1" = "move-node-to-workspace 1";
          "alt-shift-2" = "move-node-to-workspace 2";
          "alt-shift-3" = "move-node-to-workspace 3";
          "alt-shift-4" = "move-node-to-workspace 4";
          "alt-shift-5" = "move-node-to-workspace 5";
          "alt-shift-6" = "move-node-to-workspace 6";
          "alt-shift-7" = "move-node-to-workspace 7";
          "alt-shift-8" = "move-node-to-workspace 8";
          "alt-shift-9" = "move-node-to-workspace 9";
          "alt-shift-b" = "move-node-to-workspace B";
          "alt-shift-c" = "move-node-to-workspace C";
          "alt-shift-d" = "move-node-to-workspace D";
          "alt-shift-m" = "move-node-to-workspace M";
          "alt-shift-s" = "move-node-to-workspace S";
          "alt-shift-t" = "move-node-to-workspace T";

          # Workspace and monitor management
          "alt-tab" = "workspace-back-and-forth";
          "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";

          # Service mode
          "alt-shift-semicolon" = "mode service";
        };

        # Service mode bindings
        mode.service.binding = {
          "esc" = ["reload-config" "mode main"];
          "r" = ["flatten-workspace-tree" "mode main"];
          "f" = ["layout floating tiling" "mode main"];
          "backspace" = ["close-all-windows-but-current" "mode main"];
          "alt-shift-h" = ["join-with left" "mode main"];
          "alt-shift-j" = ["join-with down" "mode main"];
          "alt-shift-k" = ["join-with up" "mode main"];
          "alt-shift-l" = ["join-with right" "mode main"];
        };
      };
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # JankyBorders - adds visual borders around windows
  services.jankyborders = {
    enable = true;
    settings = {
      active_color = "0xffe1e3e4";
      inactive_color = "0xff494d64";
      width = 5.0;
    };
  };
}
