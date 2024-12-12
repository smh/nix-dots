{ inputs, outputs, ... }: {

  boot.isContainer = true;
  boot.loader.grub.enable = false;

  networking = {
    useDHCP = false;
  #   # dhcpcd.enable = false;
  #   # useNetworkd = true;
    useHostResolvConf = false;
  };

  # works with all these commented out
  # networking = {
  #   useDHCP = false;
  # #   # dhcpcd.enable = false;
  #   # useNetworkd = true;
  #   useHostResolvConf = false;
  # };

  # systemd.network = {
  #   enable = true;
  #   # networks."50-eth0" = {
  #   #   matchConfig.Name = "eth0";
  #   #   networkConfig = {
  #   #     DHCP = "ipv4";
  #   #     IPv6AcceptRA = true;
  #   #   };
  #   #   linkConfig.RequiredForOnline = "routable";
  #   # };
  # };

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];
}
