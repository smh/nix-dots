{ inputs, outputs, ... }: {

  # boot.isContainer = true;
  # boot.loader.grub.enable = false;
  # hardware.enableAllFirmware = false;

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
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  # systemd.suppressedSystemUnits = [
  #   "dev-mqueue.mount"
  #   "sys-kernel-debug.mount"
  #   "sys-fs-fuse-connections.mount"
  # ];
}
