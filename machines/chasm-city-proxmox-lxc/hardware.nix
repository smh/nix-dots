{ inputs, outputs, ... }: {

  # boot.isContainer = true;
  # boot.loader.grub.enable = false;
  # hardware.enableAllFirmware = false;

  # Interface is this on M1
  # networking.interfaces.ens160.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnsupportedSystem = true;

  networking = {
    # dhcpcd.enable = false;
    # useDHCP = false;
    useHostResolvConf = false;
  };

  # systemd.network = {
  #   enable = true;
  #   networks."50-eth0" = {
  #     matchConfig.Name = "eth0";
  #     networkConfig = {
  #       DHCP = "ipv4";
  #       IPv6AcceptRA = true;
  #     };
  #     linkConfig.RequiredForOnline = "routable";
  #   };
  # };

  # systemd.suppressedSystemUnits = [
  #   "dev-mqueue.mount"
  #   "sys-kernel-debug.mount"
  #   "sys-fs-fuse-connections.mount"
  # ];

  # Enable udev
  # services.udev = {
  #   enable = true;
  #   extraRules = "";  # Add any custom rules here if needed
  # };


  # from nixos-config/machines/hardware/vm-aarch64.nix - generated by nixos-generate-config ??
  # boot.initrd.availableKernelModules = [ "uhci_hcd" "ahci" "xhci_pci" "nvme" "usbhid" "sr_mod" ];
  # boot.initrd.kernelModules = [ ];
  # boot.kernelModules = [ ];
  # boot.extraModulePackages = [ ];

  # fileSystems."/" =
  #   { device = "/dev/disk/by-label/nixos";
  #     fsType = "ext4";
  #   };

  # fileSystems."/boot" =
  #   { device = "/dev/disk/by-label/boot";
  #     fsType = "vfat";
  #   };

  # swapDevices = [ ];

}
