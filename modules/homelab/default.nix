{ config, lib, pkgs, ... }:

let
  cfg = config.services.homelab;
in {
  options.services.homelab = with lib; {
    enable = mkEnableOption "homelab services";
    
    # mediaPath = mkOption {
    #   type = types.str;
    #   default = "/data/media";
    #   description = "Base path for media storage";
    # };
  };

  config = lib.mkIf cfg.enable {
    # System packages needed for services
    environment.systemPackages = with pkgs; [
      # Core media packages
      plex
      sonarr
      radarr
      prowlarr
      sabnzbd
      nzbhydra2

      # Support tools
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
      plex = {
        enable = true;
        openFirewall = true;
        user = "plex";
        group = "media";
        dataDir = "/var/lib/plex";
      };

      sonarr = {
        enable = true;
        user = "sonarr";
        group = "media";
        dataDir = "/var/lib/sonarr";
      };

      radarr = {
        enable = true;
        user = "radarr";
        group = "media";
        dataDir = "/var/lib/radarr";
      };

      prowlarr = {
        enable = true;
      };

      jellyseerr = {
        enable = true;
      };
    };

    # Open required ports in firewall
    networking.firewall = {
      allowedTCPPorts = [
        32400  # Plex
        8989   # Sonarr
        7878   # Radarr
        9696   # Prowlarr
        8080   # SABnzbd
        5076   # NZBHydra2
      ];
    };

    # Create shared media group and add service users to it
    users.groups.media = {
      gid = 2000;
    };

    # users.users.media = {
    #   uid = 2000;
    #   group = "media";
    # };

    # users.users = {
    #   plex.extraGroups = [ "media" ];
    #   sonarr.extraGroups = [ "media" ];
    #   radarr.extraGroups = [ "media" ];
    #   # prowlarr.extraGroups = [ "media" ];
    # };

    # Ensure media directory has correct permissions
    systemd.tmpfiles.rules = [
      "d /data 0775 root media - -"
    ];
  };
}
