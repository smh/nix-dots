{ config, lib, pkgs, ... }: {
  imports = [
    ../../modules/homelab
  ];

  services.homelab = {
    enable = true;
    nfsServer = "blackhole.lan";
    nfsShare = "/data/media";
    mediaPath = "/Volumes/Media";
  };
}
