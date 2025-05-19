{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostId = "c7a04723";

  # Enable ZFS in NixOS
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.requestEncryptionCredentials = true;

  # Use disko for disk management
  disko.devices = {
    disk = {
      # 8TB disk
      large_disk = {
        device = "/dev/disk/by-id/wwn-0x5000c500e7051021";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };

      # First 2TB disk
      first_medium_disk = {
        device = "/dev/disk/by-id/wwn-0x5000c500e400d60a";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };

      # Second 2TB disk
      second_medium_disk = {
        device = "/dev/disk/by-id/wwn-0x5000c500e400fa27";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };

      # 1TB disk
      small_disk = {
        device = "/dev/disk/by-id/wwn-0x5000c5004d179378";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };
    };

    # Define ZFS pool configuration
    zpool = {
      tank = {
        type = "zpool";
        mode = "raidz";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        mountpoint = "/storage";
        datasets = {
          "data" = {
            type = "zfs_fs";
            mountpoint = "/storage/data";
            options = {
              compression = "lz4";
              atime = "off";
              xattr = "sa";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "vms" = {
            type = "zfs_fs";
            mountpoint = "/storage/vms";
            options = {
              compression = "lz4";
              atime = "off";
              xattr = "sa";
              recordsize = "64K";
              sync = "disabled";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "backups" = {
            type = "zfs_fs";
            mountpoint = "/storage/backups";
            options = {
              compression = "lz4";
              atime = "off";
              xattr = "sa";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "docker" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker";
            options = {
              compression = "lz4";
              atime = "off";
              xattr = "sa";
              "com.sun:auto-snapshot" = "false";
            };
          };
          "services" = {
            type = "zfs_fs";
            mountpoint = "/storage/services";
            options = {
              compression = "lz4";
              atime = "off";
              xattr = "sa";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "services/gitea" = {
            type = "zfs_fs";
            mountpoint = "/storage/services/gitea";
            options = {
              compression = "lz4";
              atime = "off";
              xattr = "sa";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "services/vaultwarden" = {
            type = "zfs_fs";
            mountpoint = "/storage/services/vaultwarden";
            options = {
              compression = "lz4";
              atime = "off";
              xattr = "sa";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "services/hydra" = {
            type = "zfs_fs";
            mountpoint = "/storage/services/hydra";
            options = {
              compression = "lz4";
              atime = "off";
              xattr = "sa";
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
    };
  };

  # Create directories for ZFS mount points
  system.activationScripts.createZfsMountpoints = {
    text = ''
      mkdir -p /storage/data
      mkdir -p /storage/vms
      mkdir -p /storage/backups
      mkdir -p /storage/services
      mkdir -p /storage/services/gitea
      mkdir -p /storage/services/vaultwarden
      mkdir -p /storage/services/hydra
      mkdir -p /var/lib/docker
    '';
    deps = [];
  };

  # Enable periodic scrubbing to check for data errors
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "monthly";

  # Enable ZFS auto-snapshots
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
    frequent = 4; # Keep 4 15-minute snapshots
    hourly = 24; # Keep 24 hourly snapshots
    daily = 7; # Keep 7 daily snapshots
    weekly = 4; # Keep 4 weekly snapshots
    monthly = 3; # Keep 3 monthly snapshots
  };
}
