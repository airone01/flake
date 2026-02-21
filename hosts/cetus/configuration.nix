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
      gitea.enable = true;
      searchix.enable = true;
      traefik.enable = true;
    };
  };

  # check for zfs errors periodically
  services.zfs.autoScrub.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
