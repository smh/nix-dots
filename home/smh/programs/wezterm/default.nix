{ config, lib, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./config.lua;
  };
}
