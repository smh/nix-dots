{ inputs, outputs, ... }: {

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

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
