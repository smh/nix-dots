{
  config,
  lib,
  pkgs,
  ...
}: let
  configDir = "/var/lib/recyclarr";
in {
  users.users.recyclarr = {
    isSystemUser = true;
    group = "recyclarr";
    home = configDir;
    createHome = true;
  };
  users.groups.recyclarr = {};

  systemd.tmpfiles.rules = [
    "d ${configDir} 0755 recyclarr recyclarr -"
    "L+ ${configDir}/recyclarr.yml 0644 recyclarr recyclarr - ${./recyclarr.yml}"
  ];

  systemd.services.recyclarr-sync = {
    description = "Recyclarr Sync Service";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      User = "recyclarr";
      Group = "recyclarr";
      ExecStart = "${pkgs.recyclarr}/bin/recyclarr sync --config ${configDir}/recyclarr.yml";
      WorkingDirectory = configDir;

      StandardOutput = "journal";
      StandardError = "journal";
      SyslogIdentifier = "recyclarr";
      LogRateLimitIntervalSec = 0;

      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      ReadWritePaths = [configDir];
    };
  };

  systemd.timers.recyclarr-sync = {
    description = "Timer for Recyclarr Sync";
    wantedBy = ["timers.target"];

    timerConfig = {
      OnCalendar = "0 */12 * * *"; # Every 12 hours
      Persistent = true;
      RandomizedDelaySec = "5m";
    };
  };
}
