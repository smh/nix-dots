{ config, lib, pkgs, ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
      upgrade = true;
    };

    taps = [
      # "homebrew/cask"
      # "homebrew/core"
      "homebrew/services"
    ];

    brews = [];

    masApps = {}; 

    global = {
      brewfile = true;
      lockfiles = true;
    };
  };
}
