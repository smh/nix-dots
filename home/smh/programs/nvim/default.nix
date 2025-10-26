{
  config,
  lib,
  pkgs,
  ...
}: {
  # Enable Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # Let LazyVim manage plugins, we just provide the binary
    package = pkgs.neovim-unwrapped;
  };

  # Symlink LazyVim config from this directory
  xdg.configFile."nvim" = {
    source = ./.; # Points to home/smh/programs/nvim/
    recursive = true;
  };

  # LazyVim dependencies
  home.packages = with pkgs; [
    # Core dependencies
    ripgrep # Telescope fuzzy finder
    fd # File finder
    # lazygit is already enabled via programs.lazygit in main config

    # Language servers and tools (add as needed)
    # Lua
    lua-language-server
    stylua

    # Nix
    nil # Nix LSP
    alejandra # Nix formatter (already used by this repo)

    # Optional but useful
    tree-sitter # Better syntax highlighting
    gcc # Required for treesitter parsers compilation
  ];
}
