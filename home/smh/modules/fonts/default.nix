{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (nerd-fonts.override {fonts = ["FiraCode"];})
  ];
}
