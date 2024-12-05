{ config, lib, pkgs, ... }:

let
  domain = "hl.hustad.dev";
in {
  services.caddy = {
    enable = true;
    
    virtualHosts = {
      "bazarr.${domain}" = {
        extraConfig = ''
          reverse_proxy :6768 {
            header_up Host {host}
          }
        '';
      };

      #nzbhydra2
      "hydra.${domain}" = {
        extraConfig = ''
          reverse_proxy :5075 {
            header_up Host {host}
          }
        '';
      };

      "lidarr.${domain}" = {
        extraConfig = ''
          reverse_proxy :8787 {
            header_up Host {host}
          }
        '';
      };

      "plex.${domain}" = {
        extraConfig = ''
          reverse_proxy :32400 {
            header_up Host {host}
            header_up X-Forwarded-Proto https
          }
        '';
      };

      "prowlarr.${domain}" = {
        extraConfig = ''
          reverse_proxy :9697 {
            header_up Host {host}
          }
        '';
      };

      "radarr.${domain}" = {
        extraConfig = ''
          reverse_proxy :7879 {
            header_up Host {host}
          }
        '';
      };

      "readarr.${domain}" = {
        extraConfig = ''
          reverse_proxy :8788 {
            header_up Host {host}
          }
        '';
      };

      # Jellyseerr
      "request.${domain}" = {
        extraConfig = ''
          reverse_proxy :5055 {
            header_up Host {host}
          }
        '';
      };

      # Sabnzbd
      "sab.${domain}" = {
        extraConfig = ''
          reverse_proxy :9090 {
            header_up Host {host}
          }
        '';
      };

      "sonarr.${domain}" = {
        extraConfig = ''
          reverse_proxy :9898 {
            header_up Host {host}
          }
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
