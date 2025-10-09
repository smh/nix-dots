{
  inputs,
  outputs,
  ...
}: {
  boot.isContainer = true;
  boot.loader.grub.enable = false;

  networking = {
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];
}
