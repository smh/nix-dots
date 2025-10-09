{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.wezterm = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    extraConfig = builtins.readFile ./config.lua;
  };
}
