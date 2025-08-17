# Complete Disko config for:
# - 256GB SSD for NixOS system (with keyfile for LUKS)
# - 4 HDDs (8TB + 2x2TB + 1TB) with LUKS encryption + ZFS
_: {
  # networking.hostId = lib.mkDefault "c7a04723";
  # Need to check this is valid        /\

  boot.supportedFilesystems = ["zfs"];
  boot.kernelParams = [
    "zfs.zfs_arc_max=17179869184" # 16GB ARC max
    # TODO check if I have enough ram for this lol
  ];

  # generate the keyfile during system activation
  system.activationScripts.generateLuksKeyfile = ''
    if [ ! -f /boot/cryptkey ]; then
      echo "Generating LUKS keyfile..."
      dd if=/dev/random of=/boot/cryptkey bs=1024 count=4
      chmod 0400 /boot/cryptkey
    fi
  '';

  # disko configuration
  disko.devices = {
    disk = {
      # system SSD - 256GB for NixOS
      system-ssd = {
        device = "/dev/disk/by-id/ata-MY_SSD_ID"; # UPDATE THIS!
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults"];
              };
            };
            root = {
              label = "nixos";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = ["defaults" "noatime"];
              };
            };
          };
        };
      };

      # 8TB storage disk with LUKS
      large_disk = {
        device = "/dev/disk/by-id/wwn-0x5000c500e7051021";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt-8tb";
                # use settings for initial creation
                settings = {
                  keyFile = "/tmp/cryptkey"; # temporary location during creation
                  allowDiscards = true;
                };
                # additional settings for runtime
                additionalKeyFiles = ["/boot/cryptkey"];
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };

      # first 2TB disk with LUKS
      first_medium_disk = {
        device = "/dev/disk/by-id/wwn-0x5000c500e400d60a";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt-2tb-1";
                settings = {
                  keyFile = "/tmp/cryptkey";
                  allowDiscards = true;
                };
                additionalKeyFiles = ["/boot/cryptkey"];
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };

      # second 2TB disk with LUKS
      second_medium_disk = {
        device = "/dev/disk/by-id/wwn-0x5000c500e400fa27";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt-2tb-2";
                settings = {
                  keyFile = "/tmp/cryptkey";
                  allowDiscards = true;
                };
                additionalKeyFiles = ["/boot/cryptkey"];
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };

      # 1TB disk with LUKS
      small_disk = {
        device = "/dev/disk/by-id/wwn-0x5000c5004d179378";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt-1tb";
                settings = {
                  keyFile = "/tmp/cryptkey";
                  allowDiscards = true;
                };
                additionalKeyFiles = ["/boot/cryptkey"];
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };
    };

    # ZFS pool configuration using the LUKS-encrypted devices
    zpool = {
      tank = {
        type = "zpool";
        # don't use mode here, we'll specify vdevs manually
        postCreateHook = ''
          # create the pool with proper vdev layout
          zpool destroy tank || true
          zpool create -f -o ashift=12 -o autotrim=on \
            -O compression=lz4 -O atime=off -O xattr=sa -O acltype=posixacl \
            -O mountpoint=none \
            tank \
            mirror /dev/mapper/crypt-2tb-1 /dev/mapper/crypt-2tb-2 \
            /dev/mapper/crypt-8tb \
            /dev/mapper/crypt-1tb
        '';

        options = {
          ashift = "12";
          autotrim = "on";
        };

        rootFsOptions = {
          compression = "lz4";
          atime = "off";
          xattr = "sa";
          acltype = "posixacl";
          mountpoint = "none";
        };

        datasets = {
          # prefer mirror vdev here
          "critical" = {
            type = "zfs_fs";
            mountpoint = "/tank/critical";
            options = {
              compression = "lz4";
              atime = "off";
              copies = "2"; # extra redundancy
              "com.sun:auto-snapshot" = "true";
            };
          };

          # general data storage
          "data" = {
            type = "zfs_fs";
            mountpoint = "/tank/data";
            options = {
              compression = "lz4";
              atime = "off";
              recordsize = "128K";
              "com.sun:auto-snapshot" = "true";
            };
          };

          "vms" = {
            type = "zfs_fs";
            mountpoint = "/tank/vms";
            options = {
              compression = "lz4";
              atime = "off";
              recordsize = "64K";
              sync = "standard";
              "com.sun:auto-snapshot" = "true";
            };
          };

          "backups" = {
            type = "zfs_fs";
            mountpoint = "/tank/backups";
            options = {
              compression = "zstd";
              atime = "off";
              recordsize = "1M";
              "com.sun:auto-snapshot" = "true";
            };
          };

          "docker" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker";
            options = {
              compression = "lz4";
              atime = "off";
              "com.sun:auto-snapshot" = "false";
            };
          };

          "services" = {
            type = "zfs_fs";
            mountpoint = "/tank/services";
            options = {
              compression = "lz4";
              atime = "off";
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
    };
  };

  # boot config for LUKS
  boot.initrd.luks.devices = {
    "crypt-8tb" = {
      device = "/dev/disk/by-id/wwn-0x5000c500e7051021-part1";
      keyFile = "/cryptkey"; # path in initrd
      allowDiscards = true;
    };
    "crypt-2tb-1" = {
      device = "/dev/disk/by-id/wwn-0x5000c500e400d60a-part1";
      keyFile = "/cryptkey";
      allowDiscards = true;
    };
    "crypt-2tb-2" = {
      device = "/dev/disk/by-id/wwn-0x5000c500e400fa27-part1";
      keyFile = "/cryptkey";
      allowDiscards = true;
    };
    "crypt-1tb" = {
      device = "/dev/disk/by-id/wwn-0x5000c5004d179378-part1";
      keyFile = "/cryptkey";
      allowDiscards = true;
    };
  };

  # include keyfile in initrd
  boot.initrd.secrets = {
    "/cryptkey" = "/boot/cryptkey";
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod"];

  # ZFS services configuration
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };

    autoSnapshot = {
      enable = true;
      frequent = 4;
      hourly = 24;
      daily = 30;
      weekly = 4;
      monthly = 6;
    };

    trim = {
      enable = true;
      interval = "weekly";
    };

    zed = {
      enable = true;
      settings = {
        ZED_EMAIL_ADDR = ["admin@example.com"]; # UPDATE THIS!
        ZED_EMAIL_PROG = "mail"; # or "sendmail" idk
        ZED_NOTIFY_VERBOSE = true;
      };
    };
  };

  # create mount points
  system.activationScripts.createZfsMountpoints = {
    text = ''
      mkdir -p /tank/{critical,data,vms,backups,services}
      mkdir -p /var/lib/docker
    '';
    deps = [];
  };

  # backup script for LUKS headers and keyfile
  environment.etc."luks-backup.sh" = {
    mode = "0700";
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      BACKUP_DIR="/tank/critical/luks-backups/$(date +%Y%m%d-%H%M%S)"
      mkdir -p "$BACKUP_DIR"

      echo "Backing up LUKS keyfile..."
      cp /boot/cryptkey "$BACKUP_DIR/cryptkey.backup"

      echo "Backing up LUKS headers..."
      for dev in 8tb 2tb-1 2tb-2 1tb; do
        device=$(cryptsetup status crypt-$dev | grep device: | awk '{print $2}')
        if [[ -n "$device" ]]; then
          cryptsetup luksHeaderBackup "$device" \
            --header-backup-file "$BACKUP_DIR/luks-header-$dev.backup"
          echo "  Backed up header for crypt-$dev"
        fi
      done

      echo "Creating encrypted archive..."
      cd "$(dirname "$BACKUP_DIR")"
      tar -czf - "$(basename "$BACKUP_DIR")" | \
        gpg --cipher-algo AES256 -c > "$BACKUP_DIR.tar.gz.gpg"

      echo "Cleaning up unencrypted backup..."
      rm -rf "$BACKUP_DIR"

      echo "Backup complete: $BACKUP_DIR.tar.gz.gpg"
      echo "IMPORTANT: Copy this file to multiple secure offsite locations!"
    '';
  };
}
