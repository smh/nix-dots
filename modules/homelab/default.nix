{ config, lib, pkgs, ... }:

let
  cfg = config.services.homelab;
in {
  imports = [
    ./caddy.nix
    ./certbot.nix
  ];

  # System packages needed for services
  environment.systemPackages = with pkgs; [
    ffmpeg
    mediainfo
  ];

  # NFS client support
  services.rpcbind.enable = true;
  
  # NFS mount configuration
  fileSystems = {
    "/data" = {
      device = "blackhole.lan:/data";
      fsType = "nfs";
      options = [
        "nofail"          # Don't fail boot if mount fails
        "soft"            # Return errors rather than hang
        "timeo=15"        # Timeout after 15 seconds
        "retrans=2"       # Number of retries before failure
        "rw"             # Mount read-write
        "x-systemd.automount"  # Automount on access
        "x-systemd.idle-timeout=600"  # Unmount after 10 minutes of inactivity
      ];
    };
  };

  # Enable and configure media services
  services = {
    bazarr = {
      enable = true;
      openFirewall = true;
    };

    jellyseerr = {
      enable = true;
      openFirewall = true;
    };

    lidarr = {
      enable = true;
      openFirewall = true;
      dataDir = "/var/lib/lidarr";
    };

    nzbhydra2 = {
      enable = true;
      openFirewall = true;
      dataDir = "/var/lib/nzbhydra2";
    };

    plex = {
      enable = true;
      openFirewall = true;
      dataDir = "/var/lib/plex";
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
    };

    radarr = {
      enable = true;
      openFirewall = true;
      dataDir = "/var/lib/radarr";
    };

    readarr = {
      enable = true;
      openFirewall = true;
      dataDir = "/var/lib/readarr";
    };

    sabnzbd = {
      enable = true;
      openFirewall = true;
    };

    sonarr = {
      enable = true;
      openFirewall = true;
      dataDir = "/var/lib/sonarr";
    };
  };

  # Create shared media group and add service users to it
  users.groups.media = {
    gid = 2000;
  };

  users.users = {
    bazarr.extraGroups = [ "media" ];
    lidarr.extraGroups = [ "media" ];
    plex.extraGroups = [ "media" ];
    radarr.extraGroups = [ "media" ];
    readarr.extraGroups = [ "media" ];
    sabnzbd.extraGroups = [ "media" ];
    sonarr.extraGroups = [ "media" ];
  };

  # Ensure media directory has correct permissions
  systemd.tmpfiles.rules = [
    "d /data 0775 root media - -"
  ];
}
