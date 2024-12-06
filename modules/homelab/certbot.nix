{ config, lib, pkgs, ... }:

{
  # Create dedicated user for certificate management
  users.users.certbot = {
    isSystemUser = true;
    group = "certbot";
    home = "/var/lib/acme";
    createHome = true;
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJS3JA4e2jVIzVOQ6Lk6JwuZLfJk7MObSty6Vrkb3BNX pfSense ACME cert sync" # Replace with your pfSense key
    ];
  };
  users.groups.certbot = {};

  # Ensure certificate directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "z /var/lib/acme 0750 certbot certbot - -"
    "d /var/lib/acme/certs 0750 certbot certbot - -"
  ];

  # Create certificate extraction service
  systemd.services.cert-extract = {
    description = "Extract renewed certificates";
    path = [ pkgs.gnutar pkgs.gzip ];
    
    serviceConfig = {
      Type = "oneshot";
      User = "certbot";
      Group = "certbot";
      WorkingDirectory = "/var/lib/acme";
      ExecStart = pkgs.writeShellScript "extract-certs" ''
        if [ -f certs.tar.gz ]; then
          tar xzf certs.tar.gz -C certs/
	  chmod 640 certs/*
	  chown certbot:certbot certs/*
	  # Notify Caddy to reload
          systemctl reload caddy.service
        fi
      '';
    };
  };

  # Watch for new certificate archives
  systemd.paths.cert-extract = {
    description = "Watch for new certificates";
    wantedBy = [ "multi-user.target" ];
    
    pathConfig = {
      PathChanged = "/var/lib/acme/certs.tar.gz";
    };
  };

  # Configure Caddy to use the certificates
  # services.caddy = {
  #   enable = true;
  #   globalConfig = ''
  #     default_sni hl.hustad.dev
  #   '';
  #
  #   virtualHosts."*.hl.hustad.dev" = {
  #     extraConfig = ''
  #       tls {
  #         load_files /var/lib/acme/certs/fullchain.pem /var/lib/acme/certs/privkey.pem
  #       }
  #     '';
  #   };
  # };

  # Polkit rule to allow certbot to reload caddy
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "caddy.service" &&
          action.lookup("verb") == "reload" &&
          subject.user == "certbot") {
          return polkit.Result.YES;
      }
    });
  '';

  # Grant Caddy access to certificates
  users.users.caddy.extraGroups = [ "certbot" ];
}
