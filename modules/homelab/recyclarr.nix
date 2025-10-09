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
  ];

  # Use sops-nix template for recyclarr config with secrets
  sops.templates."recyclarr.yml" = {
    owner = "recyclarr";
    group = "recyclarr";
    mode = "0640";
    path = "${configDir}/recyclarr.yml";
    content = ''
      ${builtins.replaceStrings
        ["\"299dbddd87a34cd79ee9fb0b0d7773ec\"" "\"b248e1731c334e53927467579cd76af5\""]
        ["\${config.sops.placeholder.sonarr-api-key}" "\${config.sops.placeholder.radarr-api-key}"]
        (builtins.readFile ./recyclarr.yml)}
    '';
  };

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
