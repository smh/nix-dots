{
  inputs,
  outputs,
  ...
}: {
  boot.isContainer = true;
  boot.loader.grub.enable = false;

  networking = {
    useDHCP = true;
    useHostResolvConf = false;
  };

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];
}
