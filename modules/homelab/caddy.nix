{ config, lib, pkgs, ... }:

let
  domain = "hl.hustad.dev";
  certDir = "/var/lib/acme/certs";
  mkVirtualHost = port: extraHeaders: {
    extraConfig = ''
      tls ${certDir}/fullchain.pem ${certDir}/privkey.pem
      reverse_proxy :${toString port} {
        header_up Host {host}
        ${extraHeaders}
      }
    '';
  };
in {
  services.caddy = {
    enable = true;

    # The global config should not be nested
    globalConfig = ''
      default_sni ${domain}
      auto_https off
    '';

    virtualHosts = {
      "bazarr.${domain}" = mkVirtualHost 6767 "";
      "hydra.${domain}" = mkVirtualHost 5076 "";  # nzbhydra2
      "lidarr.${domain}" = mkVirtualHost 8686 "";
      "plex.${domain}" = mkVirtualHost 32400 "header_up X-Forwarded-Proto https"; # Fixed double header_up
      "prowlarr.${domain}" = mkVirtualHost 9696 "";
      "radarr.${domain}" = mkVirtualHost 7878 "";
      "readarr.${domain}" = mkVirtualHost 8787 "";
      "request.${domain}" = mkVirtualHost 5055 ""; # Jellyseerr
      "sab.${domain}" = mkVirtualHost 8080 ""; # Sabnzbd
      "sonarr.${domain}" = mkVirtualHost 8989 "";
    };
  };


  systemd.services.caddy.serviceConfig = {
    # SupplementaryGroups = [ "certbot" ]; handled by certbot.nix
    # AssertPathExists = [
    #   "${certDir}/fullchain.pem"
    #   "${certDir}/privkey.pem"
    # ];
    unitConfig = {
      ConditionPathExists = [
        "${certDir}/fullchain.pem"
        "${certDir}/privkey.pem"
      ];
    };
  };
  # systemd.services.caddy.serviceConfig.SupplementaryGroups = [ "certbot" ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
