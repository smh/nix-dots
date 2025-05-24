{
  config,
  lib,
  pkgs,
  ...
}: {
  options.features.blackhole = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable blackhole mount";
  };
  config = {
    homebrew.casks = ["plex-media-server"];
    users.groups.media.gid = 2000;

    launchd.user.agents.plex = {
      serviceConfig = {
        Label = "com.plexapp.plexmediaserver";
        Program = "/Applications/Plex Media Server.app/Contents/MacOS/Plex Media Server";
        RunAtLoad = true;
        KeepAlive = true;
      };
    };

    system.activationScripts.postActivation.text = ''
            ENABLE_MOUNTS="${toString config.features.blackhole}"

            # Create /private/data directory if it doesn't exist
            mkdir -p /private/data

            if ! grep -q '^/-.*auto_media' /etc/auto_master; then
              if [ "$ENABLE_MOUNTS" == "true" ]; then
                echo "Adding auto_media configuration to auto_master..."
                cat << EOF | sudo tee -a /etc/auto_master

      # auto_media automounts managed by nix-darwin
      /-                      auto_media
      EOF
              else
                echo "======================================================"
                echo "Notice: auto_media entry missing from /etc/auto_master"
                echo "To add auto_media support, run enable the option"
                echo "features.blackhole in this module"
                echo "======================================================"
              fi
            fi

            # Run automount after configuration is applied
            echo "Running automount -vc..."
            /usr/sbin/automount -vc
    '';

    environment.etc = {
      "auto_media" = {
        enable = true;
        text = "/private/data -fstype=smbfs,soft,nodev,nosuid ://guest:@blackhole.lan/data";
      };
    };
  };
}
