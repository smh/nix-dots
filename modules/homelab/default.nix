{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.homelab;
  mediaDir = "/data/media";
  downloadsDir = "/data/downloads";
  configDir = "/var/lib";
in {
  imports = [
    ./caddy.nix
    ./certbot.nix
    ./recyclarr.nix
  ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # Ensure required directories exist
  systemd.tmpfiles.rules = [
    "d /etc/docker-compose 0750 root docker - -"
    "d /data 0775 root media - -"
    "d ${configDir}/bazarr 0770 root media - -"
    "d ${configDir}/jellyseerr 0770 root media - -"
    "d ${configDir}/lidarr 0770 root media - -"
    "d ${configDir}/nzbhydra2 0770 root media - -"
    "d ${configDir}/prowlarr 0770 root media - -"
    "d ${configDir}/radarr 0770 root media - -"
    "d ${configDir}/readarr 0770 root media - -"
    "d ${configDir}/sabnzbd 0770 root media - -"
    "d ${configDir}/sonarr 0770 root media - -"
  ];

  environment.etc."docker-compose/arr-stack.yml" = {
    text = ''
      x-common: &common-config
        environment:
          PUID: "2000"
          PGID: "2000"
          TZ: "Asia/Dubai"
        network_mode: "host"
        restart: "unless-stopped"

      services:
        sonarr:
          image: linuxserver/sonarr:latest
          container_name: sonarr
          <<: *common-config
          volumes:
            - ${configDir}/sonarr:/config
            - /data:/data
          ports:
            - "8989:8989"

        radarr:
          image: linuxserver/radarr:latest
          container_name: radarr
          <<: *common-config
          volumes:
            - ${configDir}/radarr:/config
            - /data:/data
          ports:
            - "7878:7878"

        lidarr:
          image: linuxserver/lidarr:latest
          container_name: lidarr
          <<: *common-config
          volumes:
            - ${configDir}/lidarr:/config
            - /data:/data
          ports:
            - "8686:8686"

        readarr:
          image: linuxserver/readarr:develop
          container_name: readarr
          <<: *common-config
          volumes:
            - ${configDir}/readarr:/config
            - /data:/data
          ports:
            - "8787:8787"

        prowlarr:
          image: linuxserver/prowlarr:latest
          container_name: prowlarr
          <<: *common-config
          volumes:
            - ${configDir}/prowlarr:/config
          ports:
            - "9696:9696"

        bazarr:
          image: linuxserver/bazarr:latest
          container_name: bazarr
          <<: *common-config
          volumes:
            - ${configDir}/bazarr:/config
            - /data:/data
          ports:
            - "6767:6767"

        jellyseerr:
          image: fallenbagel/jellyseerr:latest
          container_name: jellyseerr
          <<: *common-config
          volumes:
            - ${configDir}/jellyseerr:/app/config
          ports:
            - "5055:5055"

        nzbhydra2:
          image: linuxserver/nzbhydra2:latest
          container_name: nzbhydra2
          <<: *common-config
          volumes:
            - ${configDir}/nzbhydra2:/config
            - /data/usenet:/data/usenet
          ports:
            - "5076:5076"

        sabnzbd:
          image: linuxserver/sabnzbd:latest
          container_name: sabnzbd
          <<: *common-config
          volumes:
            - ${configDir}/sabnzbd:/config
            - /data/usenet:/data/usenet
          ports:
            - "8080:8080"
    '';
  };

  systemd.services.docker-arr-stack = {
    description = "Docker Compose Stack for *arr Services";
    after = [
      "docker.service"
      "docker.socket"
      "data.mount"
      "remote-fs.target"
    ];
    requires = [
      "docker.service"
      "data.mount"
      "remote-fs.target"
    ];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/etc/docker-compose";
      User = "root";
      Group = "docker";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f arr-stack.yml up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f arr-stack.yml down";

      # ExecStartPre = pkgs.writeShellScript "wait-for-nfs" ''
      #   MAX_ATTEMPTS=6  # 30 seconds with 5s sleep
      #   attempt=1
      #
      #   # echo "Waiting for /data NFS mount..."
      #   while ! mountpoint -q /data; do
      #     if [ $attempt -ge $MAX_ATTEMPTS ]; then
      #       echo "Timeout waiting for /data NFS mount after 30 seconds"
      #       exit 1
      #     fi
      #     echo "Attempt $attempt/$MAX_ATTEMPTS: /data not mounted, waiting 5s..."
      #     sleep 5
      #     attempt=$((attempt + 1))
      #   done
      #   # echo "/data NFS mount is ready"
      # '';
    };
  };

  # NFS client support
  services.rpcbind.enable = true;

  # NFS mount configuration
  fileSystems = {
    "/data" = {
      device = "blackhole.lan:/data";
      fsType = "nfs";
      options = [
        "_netdev"
        "nofail"
        "soft"
        "timeo=15"
        "retrans=2"
        "rw"
        # "x-systemd.required=network-online.target"
        # automount doesn't work with lxc containers
        # "x-systemd.automount"
        # "x-systemd.idle-timeout=600"
      ];
      # neededForBoot = false;
      # wantedBy = [ "multi-user.booot" ];
      # requires = [ "network-online.target" ];
      # after = [ "network-online.target" ];
    };
  };

  # # Keep only non-arr services in the native Nix configuration
  # services = {
  #   # now running on macos
  #   # plex = {
  #   #   enable = true;
  #   #   openFirewall = true;
  #   #   group = "media";
  #   #   dataDir = "/var/lib/plex";
  #   # };
  # };

  # Create shared media group and add service users to it
  users.groups.media = {
    gid = 2000;
  };

  users.users.smh.extraGroups = ["media" "docker"];
}
