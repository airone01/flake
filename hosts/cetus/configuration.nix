_: {
  imports = [./hardware-configuration.nix];

  networking = {
    hostName = "cetus";
    hostId = "c2bd1785";
  };
  system.stateVersion = "25.05"; # never change this
  time.timeZone = "Europe/Paris";

  stars = {
    mainUser = "rack";

    core = {
      enable = true;
      shellConfig = true;
    };

    server = {
      enable = true;

      ssh-server = {
        enable = true;
        permitRootLogin = "prohibit-password";
        passwordAuthentication = false;
        listenAddresses = [
          {
            addr = "0.0.0.0";
            port = 22;
          }
        ];
        allowGroups = ["wheel"];
      };

      anubis.enable = true;
      hercules-ci.enable = true;
      gitea.enable = true;
      searchix.enable = true;
      traefik.enable = true;
    };
  };

  systemd.services.nix-daemon.serviceConfig = {
    MemoryMax = "20G"; # prevent nix from killing server
    MemorySwapMax = "2G";
  };

  systemd.services.hercules-ci-agent = {
    # tell the boehm GC to start with a tiny heap, forcing it to
    # garbage collect continuously which saves RAM at the cost of some CPU time
    environment.GC_INITIAL_HEAP_SIZE = "100000";
  };

  # check for zfs errors periodically
  services.zfs.autoScrub.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
