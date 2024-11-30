{ config, lib, pkgs, ... }:

let
  cfg = config.services.homelab;
in {
  options.services.homelab = with lib; {
    enable = mkEnableOption "homelab services";
    
    mediaPath = mkOption {
      type = types.str;
      default = "/Volumes/Media";
      description = "Base path for media storage";
    };

    nfsServer = mkOption {
      type = types.str;
      description = "NFS server hostname or IP";
    };

    nfsShare = mkOption {
      type = types.str;
      description = "NFS share path on server";
    };
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

    # NFS automount setup for macOS
    system.activationScripts.automount-media = ''
      # Add our media mount to auto_master if not already present
      if ! grep -q '${cfg.mediaPath}' /etc/auto_master; then
        echo '${cfg.mediaPath}    auto_media    -nobrowse,hidefromfinder' | sudo tee -a /etc/auto_master
      fi
    '';

    environment.etc."auto_media" = {
      text = ''
        * -fstype=nfs,soft,timeo=15,retrans=2,rw ${cfg.nfsServer}:${cfg.nfsShare}
      '';
    };

    # For now, we'll only enable Plex as it's the only service with native darwin support
    # services.plex = {
    #   enable = true;
    #   openFirewall = true;
    # };

    # TODO: For other services, we'll need to set up launchd services manually
    # or use alternatives like running them in containers
  };
}
