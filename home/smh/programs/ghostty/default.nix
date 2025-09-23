{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.ghostty = {
    enable = true;

    # Use binary package since source package isn't available on aarch64-darwin
    package = pkgs.ghostty-bin;

    # Enable shell integrations for fish (your default shell)
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    # Enable syntax highlighting support
    installBatSyntax = true;
    installVimSyntax = true;

    # Configuration settings migrated from existing config
    settings = {
      theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
    };
  };
}
