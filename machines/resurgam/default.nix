{
  inputs,
  outputs,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./hardware.nix
    ../../modules/nixos
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users.smh = import ../../home/smh;
  };

  time.timeZone = "Asia/Dubai";
  services.openssh.enable = true;

  networking.hostName = "resurgam";

  # Docker for running databases and applications
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # nix-ld for running precompiled binaries (IntelliJ Gateway, Playwright)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Core libraries
      stdenv.cc.cc.lib  # C++ standard library
      zlib              # Compression (Git, many tools)
      openssl           # TLS/SSL for Git, network
      curl              # Network operations
      icu               # Unicode support (needed by many tools)
      libgcc            # GCC runtime

      # Playwright browser dependencies
      nss
      nspr
      dbus
      atk
      at-spi2-atk
      expat
      libxcb
      libxkbcommon
      at-spi2-core
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      mesa
      libgbm
      libdrm
      pango
      cairo
      gdk-pixbuf
      glib
      gtk3
      cups
      systemd  # provides libudev
      alsa-lib
    ];
  };

  # Development packages for Java/React development
  environment.systemPackages = with pkgs; [
    docker-compose
    git
    # Java development
    graalvm-ce
    maven
    gradle
    # Node.js for React development
    nodejs_24
    # Useful tools
    vim
    tmux
    htop
    curl
    wget
    # mainly for the correct terminal xterm-ghostty
    ghostty
    # inputs.ghostty.packages.x86_64-linux.default
  ];

  #environment.etc."terminfo/x/xterm-ghostty".source = "${pkgs.ghostty}/share/terminfo/x/xterm-ghostty";


  users.users.smh.extraGroups = ["docker"];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # sops-nix configuration
  sops = {
    defaultSopsFile = ../../secrets/common.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };
}
