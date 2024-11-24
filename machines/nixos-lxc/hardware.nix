{ inputs, outputs, ... }: {
  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv5AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
