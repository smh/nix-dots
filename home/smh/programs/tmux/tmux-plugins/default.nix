final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    catppuccin = prev.tmuxPlugins.mkTmuxPlugin {
      pluginName = "catppuccin";
      version = "2.1.1";
      src = prev.fetchFromGitHub {
        owner = "catppuccin";
        repo = "tmux";
        rev = "v2.1.1";
        hash = "sha256-9+SpgO2Co38I0XnEbRd7TSYamWZNjcVPw6RWJIHM+4c=";
      };
    };
    vim-tmux-navigator = prev.tmuxPlugins.mkTmuxPlugin {
      pluginName = "vim-tmux-navigator";
      rtpFilePath = "vim-tmux-navigator.tmux";
      version = "2024-11-03";
      src = prev.fetchFromGitHub {
        owner = "christoomey";
        repo = "vim-tmux-navigator";
        rev = "2d8bc8176af90935fb918526b0fde73d6ceba0df";
        hash = "sha256-ZwJuBG0P20eQ9uVHeWF4Z8AaFo14MxNSCdjW/O6vLws=";
      };
    };
    # Add more plugin overrides here as needed
  };
}
