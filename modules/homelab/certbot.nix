{ config, lib, pkgs, ... }:

{
  # Create dedicated user for certificate management
  users.users.certbot = {
    isSystemUser = true;
    group = "certbot";
    home = "/var/lib/acme";
    homeMode = "0750";
    createHome = true;
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJS3JA4e2jVIzVOQ6Lk6JwuZLfJk7MObSty6Vrkb3BNX pfSense ACME cert sync" # Replace with your pfSense key
    ];
  };
  users.groups.certbot = {};

  # Create certificate extraction service
  systemd.services.cert-extract = {
    description = "Extract renewed certificates";
    path = [ pkgs.gnutar pkgs.gzip ];
    
    serviceConfig = {
      Type = "oneshot";
      User = "certbot";
      Group = "certbot";
      UMask = "0027";
      WorkingDirectory = "/var/lib/acme";
      ExecStart = pkgs.writeShellScript "extract-certs" ''
        if [ -f certs.tar.gz ]; then
	  mkdir -p certs
          tar xzf certs.tar.gz -C certs/
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
}
