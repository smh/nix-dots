{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.jellyseerr;
in
{
  meta.maintainers = [ maintainers.camillemndn ];

  disabledModules = [ "services/misc/jellyseerr.nix" ];

  options.services.jellyseerr = {
    enable = mkEnableOption (mdDoc ''Jellyseerr, a requests manager for Jellyfin'');

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''Open port in the firewall for the Jellyseerr web interface.'';
    };

    port = mkOption {
      type = types.port;
      default = 5055;
      description = mdDoc ''The port which the Jellyseerr web UI should listen to.'';
    };

    package = mkOption {
        type = types.package;
        default = pkgs.jellyseerr;
        defaultText = literalExpression "pkgs.jellyseerr";
        description = lib.mdDoc ''
          Jellyseerr package to use.
        '';
      };
  };

  config = mkIf cfg.enable {
    systemd.services.jellyseerr = {
      description = "Jellyseerr, a requests manager for Jellyfin";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.PORT = toString cfg.port;
      serviceConfig = {
        Type = "exec";
        StateDirectory = "jellyseerr";
        WorkingDirectory = "${cfg.package}/libexec/jellyseerr/deps/jellyseerr";
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/jellyseerr";
        BindPaths = [ "/var/lib/jellyseerr/:${cfg.package}/libexec/jellyseerr/deps/jellyseerr/config/" ];
        Restart = "on-failure";
        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
