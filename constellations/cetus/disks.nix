# Complete Disko config for:
# - 256GB SSD for system
# - 4 HDDs (8TB + 2x2TB + 1TB) with LUKS encryption + ZFS
_: {
  disko.devices = {
    disk = {
      system-ssd = {
        device = "/dev/disk/by-id/wwn-0x690b11c00656e70017f8aa9716e57358";
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
              };
            };

            root = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypt-root";
                settings = {allowDiscards = true;};
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };

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
                settings = {allowDiscards = true;};
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };

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
                settings = {allowDiscards = true;};
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };

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
                settings = {allowDiscards = true;};
                content = {
                  type = "zfs";
                  pool = "tank";
                };
              };
            };
          };
        };
      };

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
                settings = {allowDiscards = true;};
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
  };

  disko.zpool = {
    tank = {
      type = "zpool";

      rootFsOptions = {
        compression = "lz4";
        atime = "off";
        mountpoint = "none";
      };

      datasets = {
        tank = {
          type = "zfs_fs";
          options = {
            mountpoint = "/tank";
            compression = "lz4";
            atime = "off";
          };
        };
      };
    };
  };
}
